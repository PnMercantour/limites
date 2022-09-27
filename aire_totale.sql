create or replace view limites.aire_totale as
select grid.cd_sig,
    fragment.id_grid,
    fragment.geom,
    round(fragment.surface) surface_totale,
    grid.surface_coeur,
    grid.surface_aire_adhesion,
    grid.nom_vallee,
    grid.surface_vallee
from limites.grid1k_area fragment
    join limites.grid on (fragment.id_grid = grid.id)
where id_area = limites.get_id_area('limites', 'aire_totale');