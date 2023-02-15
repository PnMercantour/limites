with source as (
    select id as id_parent,
        st_xmin(geom) x,
        st_ymin(geom) y
    from limites.maille1k
)
insert into limites.maille500m (position, id_parent, geom)
select 'SO' as position,
    id_parent,
    st_setsrid(ST_makeenvelope(x, y, x + 500, y + 500), 2154) as geom
from source
union all
select 'SE' as position,
    id_parent,
    st_setsrid(
        ST_makeenvelope(x + 500, y, x + 1000, y + 500),
        2154
    ) as geom
from source
union all
select 'NO' as position,
    id_parent,
    st_setsrid(
        ST_makeenvelope(x, y + 500, x + 500, y + 1000),
        2154
    ) as geom
from source
union all
select 'NE' as position,
    id_parent,
    st_setsrid(
        ST_makeenvelope(x + 500, y + 500, x + 1000, y + 1000),
        2154
    ) as geom
from source;