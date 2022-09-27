create or replace view limites.grid as
select mk.id,
    mk.cd_sig,
    mk.geom,
    coalesce(round(coeur.surface), 0) surface_coeur,
    coalesce(round(aire_adhesion.surface), 0) surface_aire_adhesion,
    coalesce(round(aire_optimale_adhesion.surface), 0) surface_aoa,
    coalesce(round(vallee.surface), 0) surface_vallee,
    vallee.name nom_vallee
from limites.maille1k mk
    left join (
        select id_grid,
            surface
        from limites.grid1k_area
        where id_area = 1
    ) coeur on mk.id = coeur.id_grid
    left join (
        select id_grid,
            surface
        from limites.grid1k_area
        where id_area = 2
    ) aire_adhesion on mk.id = aire_adhesion.id_grid
    left join (
        select id_grid,
            surface
        from limites.grid1k_area
        where id_area = 5
    ) aire_optimale_adhesion on mk.id = aire_optimale_adhesion.id_grid
    left join (
        select distinct on (id_grid) cache.id_grid,
            cache.surface,
            area.name
        from limites.grid1k_area cache
            join limites.area on cache.id_area = area.id
        where area.id_type = 3
        order by id_grid,
            cache.surface desc
    ) vallee on mk.id = vallee.id_grid;