## grid1k_area

Intersections des mailles 1000 et des polygones remarquables du PNM (les multipolygones de la table area)

### Utilisation de la table grid1k_area

La table peut être utilisée directement ou en conjonction avec les mailles 1000 pour déterminer les relations géométriques entre une géométrie arbitraire et l'un des multipolygones.

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
