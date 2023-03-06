# Limites

Le schema `limites` donne accès aux données géographiques réglementaires du Parc national du Mercantour:
 - les limites des différentes zones du PNM,
 - la liste des communes de l'aire optimale d'adhésion, 
 - la répartition géographique des services territoriaux
 - ....



## Tables remarquables

Les tables suivantes peuvent être chargées directement dans QGIS.  Un style par défaut leur est <!-- (en principe) -->associé. 

 - limites.limites
 - limites.communes
 - limites.maille500m
 - limites.maille1k
 - limites.maille10k



## Description détaillée des tables
_Les tableaux suivants décrivent les principales tables du schéma, et certaines de leur variables. Sauf précision, il s'agit de tables._

### limites.area

Objets géographiques remarquables du PNM (zones réglementaires, communes, vallées ...)


| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| id_type   | int        | numéro de correspondance avec la table _area.type_     |
| name   | string        | nom de l'objet     | <!-- remplacer "name" par "nom" -->
| description   | string        | ...     |
| geom   | geometry (multipolygon)        | ... |


<!-- Permet de traiter de façon uniforme les objets géographiques remarquables de types différents (par exemple le calcul de l'intersection de ces objets avec les mailles 1km) -->


### limites.area_type

Table de correspondance pour les objets géographiques remarquables.

| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| type   | int        | numéro d'identifiant de type d'objet géographique - fait la correspondance avec id_type de _limites.area_     |
| description      | string       |  ...   |

### limites.communes
Contient 28 entités.

| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| nom   | string        | nom de la commune  |
| code_insee      | int       | ...|
| canton/depart/ arrondisst/region     | str       |  nom de l'entité géographique  |
| popul | int       | population au dernier recensement <!-- lequel? --> |
| addhesion      | string       | deux valeurs: "oui", "non", concernant l'adhésion à la charte du PNM   |


### limites.grid (Vue)
<!-- est-ce que cette grille couvre l'ensemble?  -->
Vue de synthèse donnant pour chaque maille de limites.maille1k la surface appartenant à chaque zone, et le nom de la vallée principale.


### limites.grid1k_area

_Ne contient que les polygones qui sont dans le parc_

Intersections des mailles 1000 et des polygones remarquables du PNM (table _area_),
c'est-à-dire qu'il contient des mailles fragmentées selon les zones qui les recouvrent.

| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id_grid      | (PK) int       |   ... |
|id_area	| (PK) int|  ...|
| surface   | string        | nom de la commune  |
| geom      | geometry       | ...|


### limites.limites
Contient 6 entités: coeur, aire d'adhésion.....
| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| nom   | string        | nom de la zone (coeur, aire d'adhésion...)     |
| description   | string        | Détail sur le nom     |
| geom   | geometry        | nom de la zone (coeur, aire d'adhésion...)     |
| geom_simple   | geometry        | geométrie simplifiée     |

<!-- pas clair ce que la colonne "layer" veut dire -->



### limites.maille1k
Maillage de 1km de côté pavage normalisé  <!-- (EPSG:2154) les autres couches ne sont pas dans la même projection? -->

| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| id_sig   | string        |    ...  |
| code_10km   | string        | numéro identifiant la maille dans un carré de 10 km <!-- ? -->      |
| aire_*   | boolean        | indication (True/False) si la maille est dans une zone d'intérêt     |


### limites.maille500m
Maillage de 500m de côté


| Nom de la colonne      | Type | Description     |
| :---        |    :----:   |          :---: |
| id      | (PK) int       |   ... |
| position   | string        |   position de la maille 500m dans la maille 1km qui la contient (NE, NO, SE, SW)  |
| id_parent | int| id de la maille 1km parente |


______


<!-- toute la suite devrait être dans un autre document dédié au sql -->

# Utilisation du schema `limites` dans les projets SQL et QGIS

## Log Interne

Les objets géographiques remarquables du PNM (limites du parc, limites des communes du parc, services territoriaux, mailles 1km du territoire, etc) sont souvent utilisées dans les projets SQL et QGIS, ce qui nécessite l'optimisation des opérations de calcul les plus fréquentes (intersection, ...) par leur mise en cache.

Les traitements géométriques (intersections, inclusions) sont plus rapides lorsqu'il s'appliquent à des objets d'emprise réduite. On a donc découpé tous les objets géométriques remarquables suivant les mailles 1km et mis en cache la géométrie et la surface de l'intersection avec pour effet :

- l'identification immédiate des mailles 1km liées à chaque géométrie remarquable
- l'accélération des calculs de surface commune entre un objet géographique remarquable et une géométrie arbitraire.



### fonction limites.get_id_type

Retourne l'identifiant correspondant à un type. Par exemple:
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




### Exemples d'utilisation de la table grid1k_area

La table peut être utilisée directement ou en conjonction avec les mailles 1000 pour déterminer les relations géométriques entre une géométrie arbitraire et l'un des multipolygones.


Exemple: Pour retrouver la surface coeur de chaque commune

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

Pour retrouver la Surface du ST Haut Var Cians en coeur de parc

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
