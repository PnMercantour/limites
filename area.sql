-- area.sql : alimentation de la table limites.area
-- Au préalable, créer et alimenter la table limites.area_type
--
-- limites du PNM
with a as (
    select nom,
        description,
        geom
    from limites.limites
    order by id
)
insert into limites.area(area_type, name, description, geom)
select 1 as area_type,
    a.*
from a;
--
-- Services territoriaux
with a as (
    select nom,
        nom,
        geom
    from limregl.cr_pnm_services_territoriaux_topo
)
insert into limites.area(area_type, name, description, geom)
select 2 as area_type,
    a.*
from a;
--
-- Vallées
with a as (
    select nom,
        nom,
        geom
    from limregl.cr_pnm_vallees_topo
)
insert into limites.area(area_type, name, description, geom)
select 3 as area_type,
    a.*
from a;