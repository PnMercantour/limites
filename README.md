## limites.area

Table de référence des objets géographiques remarquables du PNM (zones réglementaires, communes, ...)

- id: clé primaire
- id_type: type d'objet (voir la table area_type)
- name: nom de l'objet
- description
- geom: géométrie(multipolygon) de l'objet

## fonction limites.get_id_area

    select limites.get_id_area('limites'::character varying, 'coeur'::character varying);

Retourne l'identifiant de l'objet `coeur` de type `limites`

## grid1k_area

Intersections des mailles 1000 et des polygones remarquables du PNM (les multipolygones de la table area)

- id_grid, id_area
- surface: surface de l'intersection
- geom: géométrie de l'intersection

Mise à jour de la table `grid1k_area` pour les communes (exemple à généraliser et automatiser):

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

### Utilisation de la table grid1k_area

La table peut être utilisée directement ou en conjonction avec les mailles 1000 pour déterminer les relations géométriques entre une géométrie arbitraire et l'un des multipolygones.

### Surface coeur de chaque commune

    select round(sum(case
                when gcoeur.surface = 1000000 then gcom.surface
                when gcom.surface = 1000000 then gcoeur.surface
                else st_area(st_intersection(gcoeur.geom, gcom.geom))
            end)) "surface coeur", name commune from limites.grid1k_area gcom join limites.area on gcom.id_area = area.id join (select * from limites.grid1k_area where id_area = 1) gcoeur using (id_grid)
    where area.id_type = 4
    group by area.name
    order by area.name

#### calcul de la surface d'intersection de 2 areas

```
-- méthode grid
select sum(
        case
            when a.surface = 1000000 then b.surface
            when b.surface = 1000000 then a.surface
            else st_area(st_intersection(a.geom, b.geom))
        end
    )
from limites.grid1k_area a
    join limites.grid1k_area b on a.id_grid = b.id_grid
where a.id_area = 1
    and b.id_area = 8;

-- méthode classique
select st_area(st_intersection(a.geom, b.geom))
from limites.area a,
    limites.area b
where a.id = 1
    and b.id = 8;
```

#### Calcul de l'intersection de 2 areas

```
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
where a.id_area = 6
    and b.id_area = 4;

-- methode classique
select st_intersection(a.geom, b.geom)
from limites.area a,
    limites.area b
where a.id = 6
    and b.id = 4;
```

#### Calcul de l'intersection d'une area avec une géométrie arbitraire

```
with allos as (select *
from limregl.cr_paca_communes_topo
where nom_comm = 'ALLOS'),
m_allos as (select m.id id_grid,
    st_intersection(m.geom, allos.geom) geom
from limites.maille1k m
    join allos on (st_intersects(m.geom, allos.geom))),
m_coeur as (select * from limites.grid1k_area gka
where id_area = limites.get_id_area('limites', 'coeur'))
select st_union(
    case
        -- when a.surface = 1000000 then b.geom
        when b.surface = 1000000 then a.geom
        else st_intersection(a.geom, b.geom)
    end
)
from m_allos a
    join m_coeur b on a.id_grid = b.id_grid;

with allos as (select *
from limregl.cr_paca_communes_topo
where nom_comm = 'ALLOS'),
coeur as (select * from limites.area where id = 1)
select st_intersection(allos.geom, coeur.geom)
from allos, coeur;
```
