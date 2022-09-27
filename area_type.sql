-- types de données du référentiel géographique
CREATE TABLE limites.area_type (
    id int4 NOT NULL,
    "type" varchar NOT NULL,
    description varchar NULL,
    CONSTRAINT area_type_pk PRIMARY KEY (id)
);
CREATE UNIQUE INDEX area_type_type_idx ON limites.area_type USING btree (type);