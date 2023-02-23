--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10 (Debian 13.10-1.pgdg100+1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: limites; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA limites;


ALTER SCHEMA limites OWNER TO admin;

--
-- Name: get_id_area(character varying, character varying); Type: FUNCTION; Schema: limites; Owner: admin
--

CREATE FUNCTION limites.get_id_area(mytype character varying, myname character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ --id_area pour un type et un nom donnés
DECLARE result integer;
DECLARE the_id_type integer;
BEGIN
select into the_id_type id
from limites.area_type
where type = mytype;
SELECT INTO result id
from limites.area
where id_type = the_id_type
    and name = myname;
return result;
END;
$$;


ALTER FUNCTION limites.get_id_area(mytype character varying, myname character varying) OWNER TO admin;

--
-- Name: get_id_type(character varying); Type: FUNCTION; Schema: limites; Owner: admin
--

CREATE FUNCTION limites.get_id_type(mytype character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ --id_area pour un type et un nom donnés
DECLARE the_id_type integer;
BEGIN
select into the_id_type id
from limites.area_type
where type = mytype;
return the_id_type;
END;
$$;


ALTER FUNCTION limites.get_id_type(mytype character varying) OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: maille1k; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.maille1k (
    id integer NOT NULL,
    cd_sig character varying(20),
    code_10km character varying(15),
    geom public.geometry(Polygon,2154),
    coeur boolean DEFAULT false NOT NULL,
    aire_adhesion boolean DEFAULT false NOT NULL,
    aire_optimale_adhesion boolean DEFAULT false NOT NULL,
    aire_optimale_totale boolean DEFAULT false NOT NULL,
    surface_coeur integer,
    surface_aire_adhesion integer,
    surface_aoa integer,
    surface_vallee integer,
    nom_vallee character varying
);


ALTER TABLE limites.maille1k OWNER TO admin;

--
-- Name: TABLE maille1k; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON TABLE limites.maille1k IS 'Mailles L93_1X1 sur le territoire du PNM
https://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref/referentiels';


--
-- Name: area; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.area (
    id integer NOT NULL,
    id_type integer NOT NULL,
    name character varying,
    description character varying,
    geom public.geometry(MultiPolygon,2154)
);


ALTER TABLE limites.area OWNER TO admin;

--
-- Name: grid1k_area; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.grid1k_area (
    id_grid integer NOT NULL,
    id_area integer NOT NULL,
    surface numeric,
    geom public.geometry(MultiPolygon,2154)
);


ALTER TABLE limites.grid1k_area OWNER TO admin;

--
-- Name: TABLE grid1k_area; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON TABLE limites.grid1k_area IS 'Découpage des zones remarquables suivant les mailles 1K';


--
-- Name: grid; Type: VIEW; Schema: limites; Owner: admin
--

CREATE VIEW limites.grid AS
 SELECT mk.id,
    mk.cd_sig,
    mk.geom,
    COALESCE(round(coeur.surface), (0)::numeric) AS surface_coeur,
    COALESCE(round(aire_adhesion.surface), (0)::numeric) AS surface_aire_adhesion,
    COALESCE(round(aire_optimale_adhesion.surface), (0)::numeric) AS surface_aoa,
    COALESCE(round(vallee.surface), (0)::numeric) AS surface_vallee,
    vallee.name AS nom_vallee
   FROM ((((limites.maille1k mk
     LEFT JOIN ( SELECT grid1k_area.id_grid,
            grid1k_area.surface
           FROM limites.grid1k_area
          WHERE (grid1k_area.id_area = 1)) coeur ON ((mk.id = coeur.id_grid)))
     LEFT JOIN ( SELECT grid1k_area.id_grid,
            grid1k_area.surface
           FROM limites.grid1k_area
          WHERE (grid1k_area.id_area = 2)) aire_adhesion ON ((mk.id = aire_adhesion.id_grid)))
     LEFT JOIN ( SELECT grid1k_area.id_grid,
            grid1k_area.surface
           FROM limites.grid1k_area
          WHERE (grid1k_area.id_area = 5)) aire_optimale_adhesion ON ((mk.id = aire_optimale_adhesion.id_grid)))
     LEFT JOIN ( SELECT DISTINCT ON (cache.id_grid) cache.id_grid,
            cache.surface,
            area.name
           FROM (limites.grid1k_area cache
             JOIN limites.area ON ((cache.id_area = area.id)))
          WHERE (area.id_type = 3)
          ORDER BY cache.id_grid, cache.surface DESC) vallee ON ((mk.id = vallee.id_grid)));


ALTER TABLE limites.grid OWNER TO admin;

--
-- Name: maille10k; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.maille10k (
    id integer NOT NULL,
    cd_sig character varying(50),
    code_10km character varying(50),
    geom public.geometry(Polygon,2154)
);


ALTER TABLE limites.maille10k OWNER TO admin;

--
-- Name: TABLE maille10k; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON TABLE limites.maille10k IS 'Mailles L93_10X10 sur le territoire du PNM
https://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ref/referentiels';


--
-- Name: L93_10X10_id_seq; Type: SEQUENCE; Schema: limites; Owner: admin
--

CREATE SEQUENCE limites."L93_10X10_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE limites."L93_10X10_id_seq" OWNER TO admin;

--
-- Name: L93_10X10_id_seq; Type: SEQUENCE OWNED BY; Schema: limites; Owner: admin
--

ALTER SEQUENCE limites."L93_10X10_id_seq" OWNED BY limites.maille10k.id;


--
-- Name: aire_totale; Type: VIEW; Schema: limites; Owner: admin
--

CREATE VIEW limites.aire_totale AS
 SELECT grid.cd_sig,
    fragment.id_grid,
    fragment.geom,
    round(fragment.surface) AS surface_totale,
    grid.surface_coeur,
    grid.surface_aire_adhesion,
    grid.nom_vallee,
    grid.surface_vallee
   FROM (limites.grid1k_area fragment
     JOIN limites.grid ON ((fragment.id_grid = grid.id)))
  WHERE (fragment.id_area = limites.get_id_area('limites'::character varying, 'aire_totale'::character varying));


ALTER TABLE limites.aire_totale OWNER TO admin;

--
-- Name: area_id_seq; Type: SEQUENCE; Schema: limites; Owner: admin
--

ALTER TABLE limites.area ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME limites.area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: area_type; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.area_type (
    id integer NOT NULL,
    type character varying NOT NULL,
    description character varying
);


ALTER TABLE limites.area_type OWNER TO admin;

--
-- Name: communes; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.communes (
    geom public.geometry(MultiPolygon,2154),
    prec_plani numeric(23,15),
    nom character varying(45),
    code_insee character varying(5),
    statut character varying(20),
    canton character varying(45),
    arrondisst character varying(45),
    depart character varying(30),
    region character varying(30),
    popul bigint,
    adhesion character varying(10),
    id integer NOT NULL
);


ALTER TABLE limites.communes OWNER TO admin;

--
-- Name: limites; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.limites (
    id integer NOT NULL,
    nom text NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    description character varying,
    geom_simple public.geometry(MultiPolygon,2154),
    layer integer
);


ALTER TABLE limites.limites OWNER TO admin;

--
-- Name: TABLE limites; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON TABLE limites.limites IS 'Limites réglementaires';


--
-- Name: COLUMN limites.geom_simple; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON COLUMN limites.limites.geom_simple IS 'Géométrie simplifiée';


--
-- Name: COLUMN limites.layer; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON COLUMN limites.limites.layer IS 'Ordre d''affichage QGIS';


--
-- Name: limites_id_seq; Type: SEQUENCE; Schema: limites; Owner: admin
--

CREATE SEQUENCE limites.limites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE limites.limites_id_seq OWNER TO admin;

--
-- Name: limites_id_seq; Type: SEQUENCE OWNED BY; Schema: limites; Owner: admin
--

ALTER SEQUENCE limites.limites_id_seq OWNED BY limites.limites.id;


--
-- Name: maille1k_id_seq; Type: SEQUENCE; Schema: limites; Owner: admin
--

CREATE SEQUENCE limites.maille1k_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE limites.maille1k_id_seq OWNER TO admin;

--
-- Name: maille1k_id_seq; Type: SEQUENCE OWNED BY; Schema: limites; Owner: admin
--

ALTER SEQUENCE limites.maille1k_id_seq OWNED BY limites.maille1k.id;


--
-- Name: maille500m; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.maille500m (
    id integer NOT NULL,
    "position" character(2) NOT NULL,
    geom public.geometry(Polygon,2154) NOT NULL,
    id_parent integer NOT NULL,
    CONSTRAINT maille500m_check_position CHECK (("position" = ANY (ARRAY['SE'::bpchar, 'SO'::bpchar, 'NE'::bpchar, 'NO'::bpchar])))
);


ALTER TABLE limites.maille500m OWNER TO admin;

--
-- Name: TABLE maille500m; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON TABLE limites.maille500m IS 'Mailles 500m';


--
-- Name: COLUMN maille500m."position"; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON COLUMN limites.maille500m."position" IS 'Position dans la maille 1k parente (SE, SO, NE, NO)';


--
-- Name: COLUMN maille500m.id_parent; Type: COMMENT; Schema: limites; Owner: admin
--

COMMENT ON COLUMN limites.maille500m.id_parent IS 'id de la maille 1k parente';


--
-- Name: maille500m_id_seq; Type: SEQUENCE; Schema: limites; Owner: admin
--

ALTER TABLE limites.maille500m ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME limites.maille500m_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: qgis_projects; Type: TABLE; Schema: limites; Owner: admin
--

CREATE TABLE limites.qgis_projects (
    name text NOT NULL,
    metadata jsonb,
    content bytea
);


ALTER TABLE limites.qgis_projects OWNER TO admin;

--
-- Name: limites id; Type: DEFAULT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.limites ALTER COLUMN id SET DEFAULT nextval('limites.limites_id_seq'::regclass);


--
-- Name: maille10k id; Type: DEFAULT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille10k ALTER COLUMN id SET DEFAULT nextval('limites."L93_10X10_id_seq"'::regclass);


--
-- Name: maille1k id; Type: DEFAULT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille1k ALTER COLUMN id SET DEFAULT nextval('limites.maille1k_id_seq'::regclass);


--
-- Name: maille10k L93_10X10_pkey; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille10k
    ADD CONSTRAINT "L93_10X10_pkey" PRIMARY KEY (id);


--
-- Name: area area_pk; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.area
    ADD CONSTRAINT area_pk PRIMARY KEY (id);


--
-- Name: area_type area_type_pk; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.area_type
    ADD CONSTRAINT area_type_pk PRIMARY KEY (id);


--
-- Name: communes communes_pk; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.communes
    ADD CONSTRAINT communes_pk PRIMARY KEY (id);


--
-- Name: grid1k_area grid1k_area_pk; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.grid1k_area
    ADD CONSTRAINT grid1k_area_pk PRIMARY KEY (id_grid, id_area);


--
-- Name: limites limites_pk; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.limites
    ADD CONSTRAINT limites_pk PRIMARY KEY (id);


--
-- Name: maille1k maille1k_pkey; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille1k
    ADD CONSTRAINT maille1k_pkey PRIMARY KEY (id);


--
-- Name: maille500m maille500m_pkey; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille500m
    ADD CONSTRAINT maille500m_pkey PRIMARY KEY (id);


--
-- Name: maille500m maille500m_unicite; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille500m
    ADD CONSTRAINT maille500m_unicite UNIQUE ("position", id_parent);


--
-- Name: qgis_projects qgis_projects_pkey; Type: CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.qgis_projects
    ADD CONSTRAINT qgis_projects_pkey PRIMARY KEY (name);


--
-- Name: area_type_type_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE UNIQUE INDEX area_type_type_idx ON limites.area_type USING btree (type);


--
-- Name: communes_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX communes_geom_idx ON limites.communes USING gist (geom);


--
-- Name: grid1k_area_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX grid1k_area_geom_idx ON limites.grid1k_area USING gist (geom);


--
-- Name: grid1k_area_id_area_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX grid1k_area_id_area_idx ON limites.grid1k_area USING btree (id_area);


--
-- Name: grid1k_area_id_grid_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX grid1k_area_id_grid_idx ON limites.grid1k_area USING btree (id_grid);


--
-- Name: limites_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX limites_geom_idx ON limites.limites USING gist (geom);


--
-- Name: limites_geom_simple_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX limites_geom_simple_idx ON limites.limites USING gist (geom_simple);


--
-- Name: maille10k_code_10km_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX maille10k_code_10km_idx ON limites.maille10k USING btree (code_10km);


--
-- Name: maille10k_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX maille10k_geom_idx ON limites.maille10k USING gist (geom);


--
-- Name: maille1k_code_10km_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE UNIQUE INDEX maille1k_code_10km_idx ON limites.maille1k USING btree (code_10km);


--
-- Name: maille1k_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX maille1k_geom_idx ON limites.maille1k USING gist (geom);


--
-- Name: maille500m_geom_idx; Type: INDEX; Schema: limites; Owner: admin
--

CREATE INDEX maille500m_geom_idx ON limites.maille500m USING gist (geom);


--
-- Name: area area_area_type_fk; Type: FK CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.area
    ADD CONSTRAINT area_area_type_fk FOREIGN KEY (id_type) REFERENCES limites.area_type(id);


--
-- Name: grid1k_area grid1k_area_fk; Type: FK CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.grid1k_area
    ADD CONSTRAINT grid1k_area_fk FOREIGN KEY (id_area) REFERENCES limites.area(id);


--
-- Name: grid1k_area grid1k_area_grid_fk; Type: FK CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.grid1k_area
    ADD CONSTRAINT grid1k_area_grid_fk FOREIGN KEY (id_grid) REFERENCES limites.maille1k(id);


--
-- Name: maille500m maille500m_fk; Type: FK CONSTRAINT; Schema: limites; Owner: admin
--

ALTER TABLE ONLY limites.maille500m
    ADD CONSTRAINT maille500m_fk FOREIGN KEY (id_parent) REFERENCES limites.maille1k(id);


--
-- Name: SCHEMA limites; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA limites TO PUBLIC;


--
-- Name: TABLE maille1k; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.maille1k TO PUBLIC;


--
-- Name: TABLE area; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.area TO PUBLIC;


--
-- Name: TABLE grid1k_area; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.grid1k_area TO PUBLIC;


--
-- Name: TABLE grid; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.grid TO PUBLIC;


--
-- Name: TABLE maille10k; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.maille10k TO PUBLIC;


--
-- Name: TABLE aire_totale; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.aire_totale TO PUBLIC;


--
-- Name: TABLE area_type; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.area_type TO PUBLIC;


--
-- Name: TABLE communes; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.communes TO PUBLIC;


--
-- Name: TABLE limites; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.limites TO PUBLIC;


--
-- Name: TABLE maille500m; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.maille500m TO PUBLIC;


--
-- Name: TABLE qgis_projects; Type: ACL; Schema: limites; Owner: admin
--

GRANT SELECT ON TABLE limites.qgis_projects TO PUBLIC;


--
-- PostgreSQL database dump complete
--

