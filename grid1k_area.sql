-- limites.grid1k_area definition
-- Drop table
-- DROP TABLE limites.grid1k_area;
CREATE TABLE limites.grid1k_area (
    id_grid int4 NOT NULL,
    id_area int4 NOT NULL,
    surface numeric NULL,
    geom public.geometry(multipolygon, 2154) NULL,
    CONSTRAINT grid1k_area_pk PRIMARY KEY (id_grid, id_area)
);
CREATE INDEX grid1k_area_geom_idx ON limites.grid1k_area USING gist (geom);
CREATE INDEX grid1k_area_id_area_idx ON limites.grid1k_area USING btree (id_area);
CREATE INDEX grid1k_area_id_grid_idx ON limites.grid1k_area USING btree (id_grid);
COMMENT ON TABLE limites.grid1k_area IS 'Découpage des zones remarquables suivant les mailles 1K';
-- limites.grid1k_area foreign keys
ALTER TABLE limites.grid1k_area
ADD CONSTRAINT grid1k_area_fk FOREIGN KEY (id_area) REFERENCES limites.area(id);
ALTER TABLE limites.grid1k_area
ADD CONSTRAINT grid1k_area_grid_fk FOREIGN KEY (id_grid) REFERENCES limites.maille1k(id);
-- remplissage de la table
with i as (
    select a.id id_grid,
        b.id id_area,
        b.id_type,
        st_intersection(a.geom, b.geom) geom
    from limites.maille1k a
        join limites.area b on st_intersects(a.geom, b.geom)
)
insert into limites.grid1k_area(id_grid, id_area, surface, geom)
select id_grid,
    id_area,
    st_area(geom) surface,
    st_multi(geom)
from i
where st_area(geom) > 0;