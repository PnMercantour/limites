# Utilisation du schema `limites` dans les projets SQL et QGIS

Le schema `limites` donne accès aux données géographiques réglementaires du Parc national du Mercantour, par exemple les limites réglementaires du PNM, la liste des communes de l'aire optimale d'adhésion, la répartition géographique des services territoriaux.

## Visualiser les données dans QGIS

Les tables suivantes peuvent être chargées directement dans QGIS, un style par défaut leur est (en principe) associé. Pour les traitements complexes, voir le paragraphe [utilisation avancée](#utilisation-avancée).

### limites.limites

`limites.limites` est la table des aires du PNM:

- coeur,
- aire (optimale) d'adhésion,
- aire (optimale) totale
- réserve intégrale

### limites.communes

`limites.communes` est la table des communes du PNM. Elle contient en particulier les attributs suivants:

- nom,
- code_insee,
- canton,
- depart: le département,
- popul: la population de la commune au dernier recensement,
- adhesion: le statut (oui, non) d'adhésion de la commune à la charte du PNM.

### limites.maille1k

Mailles 1km suivant la projection légale (2154), pavage normalisé.

### limites.maille10k

Mailles 10km

### limites.maille500m

Mailles de 500m de côté:

- position: la position de la maille 500m dans la maille 1km qui la contient (NE, NO, SE, SW)
- id_parent: la maille 1km parente

### limites.grid

Vue de synthèse, par maille 1km, donnant :

- cd_sig
- geom
- surface_coeur
- surface_aire_adhesion
- surface_aoa
- surface_vallee: plus grande surface d'intersection avec une vallée (vallée principale)
- nom_vallee: nom de la vallée principale pour la maille

L'ensemble des mailles de l'aire totale du PNM peut par exemple être calculé ainsi:

```sql
select * from limites.grid where surface_coeur + surface_aire_adhesion > 0;
```

## Utilisation avancée

Les objets géographiques remarquables du PNM (limites du parc, limites des communes du parc, services territoriaux, mailles 1km du territoire, etc) sont souvent utilisées dans les projets SQL et QGIS, ce qui nécessite l'optimisation des opérations de calcul les plus fréquentes (intersection, ...) par leur mise en cache.

Les traitements géométriques (intersections, inclusions) sont plus rapides lorsqu'il s'appliquent à des objets d'emprise réduite. On a donc découpé tous les objets géométriques remarquables suivant les mailles 1km et mis en cache la géométrie et la surface de l'intersection avec pour effet :

- l'identification immédiate des mailles 1km liées à chaque géométrie remarquable
- l'accélération des calculs de surface commune entre un objet géographique remarquable et une géométrie arbitraire.

### limites.area

Table de référence des objets géographiques remarquables du PNM (zones réglementaires, communes, ...)

- id: clé primaire
- id_type: type d'objet (voir la table area_type)
- name: nom de l'objet
- description
- geom: géométrie(multipolygon) de l'objet

Permet de traiter de façon uniforme les objets géographiques remarquables de types différents (par exemple le calcul de l'intersection de ces objets avec les mailles 1km)

### limites.area_type

Table de classification des objets géographiques remarquables.

- id: clé primaire
- type: identifiant de type d'objet géographique
- description: description du type d'objet géographique

### fonction limites.get_id_type

Retourne l'identifiant correspondant à un type. Par exemple

```sql
select limites.get_id_type('st');
```

retourne l'identifiant de type des services territoriaux.

### fonction limites.get_id_area

Retourne l'identifiant d'un objet géographique remarquable à partir de son type et de son nom. Par exemple

```sql
select limites.get_id_area('limites', 'coeur');
```

retourne l'identifiant de l'objet `coeur` de type `limites`.

### grid1k_area

Intersections des mailles 1000 et des polygones remarquables du PNM (les multipolygones de la table area)

- id_grid, id_area
- surface: surface de l'intersection
- geom: géométrie de l'intersection

### Utilisation de la table grid1k_area

La table peut être utilisée directement ou en conjonction avec les mailles 1000 pour déterminer les relations géométriques entre une géométrie arbitraire et l'un des multipolygones.

### Exemples d'utilisation

Surface coeur de chaque commune

```sql
select
	round(sum(case
                when gcoeur.surface = 1000000 then gcom.surface
                when gcom.surface = 1000000 then gcoeur.surface
                else st_area(st_intersection(gcoeur.geom, gcom.geom))
            end)) "surface coeur",
	name commune
from
	limites.grid1k_area gcom
join limites.area on
	gcom.id_area = area.id
join (
	select
		*
	from
		limites.grid1k_area
	where
		id_area = limites.get_id_area('limites',
		'coeur'))gcoeur
		using (id_grid)
where
	area.id_type = limites.get_id_type('communes')
group by
	area.name
order by
	area.name;
```

Surface du ST Haut Var Cians en coeur de parc

```sql
-- méthode grid
select round(sum(
        case
            when a.surface = 1000000 then b.surface
            when b.surface = 1000000 then a.surface
            else st_area(st_intersection(a.geom, b.geom))
        end
    ))
from limites.grid1k_area a
    join limites.grid1k_area b on a.id_grid = b.id_grid
where a.id_area = limites.get_id_area('limites','coeur')
    and b.id_area = limites.get_id_area('st', 'Haut Var Cians');

-- méthode classique
select round(st_area(st_intersection(a.geom, b.geom)))
from limites.area a,
    limites.area b
where a.id = limites.get_id_area('limites','coeur')
    and b.id = limites.get_id_area('st', 'Haut Var Cians');
```

Intersection du ST Haut Var Cians et du coeur de parc

```sql
-- méthode grid
select st_union(
    case
        when a.surface = 1000000 then b.geom
        when b.surface = 1000000 then a.geom
        else st_intersection(a.geom, b.geom)
    end
)
from limites.grid1k_area a
    join limites.grid1k_area b on a.id_grid = b.id_grid
where a.id_area = limites.get_id_area('limites','coeur')
    and b.id_area = limites.get_id_area('st', 'Haut Var Cians');

-- methode classique
select st_intersection(a.geom, b.geom)
from limites.area a,
    limites.area b
where a.id = limites.get_id_area('limites','coeur')
    and b.id = limites.get_id_area('st', 'Haut Var Cians');
```

### Mise à jour des données

Exemple de mise à jour manuelle de la table `grid1k_area` pour les communes (exemple à généraliser et automatiser):

    with c as (select a.id from limites.area a where id_type = 4)
    delete from limites.grid1k_area gka using c where c.id = gka.id_area

    with i as (
        select a.id id_grid,
            b.id id_area,
            st_intersection(a.geom, b.geom) geom
        from limites.maille1k a
            join limites.area b on st_intersects(a.geom, b.geom)
            where b.id_type=4
    )
    insert into limites.grid1k_area(id_grid, id_area, surface, geom)
    select id_grid,
        id_area,
        st_area(geom) surface,
        st_multi(geom)
    from i
    where st_area(geom) > 0;
