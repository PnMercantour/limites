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
-- Name: admin_express; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA admin_express;


ALTER SCHEMA admin_express OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chflieu_commune; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.chflieu_commune (
    id character varying NOT NULL,
    geom public.geometry(Point,2154),
    nom character varying(120),
    id_com character varying(24)
);


ALTER TABLE admin_express.chflieu_commune OWNER TO admin;

--
-- Name: TABLE chflieu_commune; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.chflieu_commune IS 'Chef lieu (localisation de la mairie) des communes des départements 04 et 06. Source admin_express COG carto 2022';


--
-- Name: commune; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.commune (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    nom character varying(50),
    nom_m character varying(50),
    insee_com character varying(5),
    statut character varying(26),
    population integer,
    insee_can character varying(5),
    insee_arr character varying(2),
    insee_dep character varying(3),
    insee_reg character varying(2),
    siren_epci character varying(20)
);


ALTER TABLE admin_express.commune OWNER TO admin;

--
-- Name: TABLE commune; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.commune IS 'Communes des départements 04 et 06. Source admin_express COG carto 2022';


--
-- Name: commune_associee_ou_deleguee; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.commune_associee_ou_deleguee (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    nom character varying(50),
    nom_m character varying(50),
    insee_cad character varying(5),
    insee_com character varying(5),
    nature character varying(5),
    population integer
);


ALTER TABLE admin_express.commune_associee_ou_deleguee OWNER TO admin;

--
-- Name: TABLE commune_associee_ou_deleguee; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.commune_associee_ou_deleguee IS 'Anciennes communes de Larche et Meyronnes (aujourd''hui Val d''Oronaye)';


--
-- Name: departement; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.departement (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    nom_m character varying(30),
    nom character varying(30),
    insee_dep character varying(3),
    insee_reg character varying(2)
);


ALTER TABLE admin_express.departement OWNER TO admin;

--
-- Name: TABLE departement; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.departement IS 'Départements de la région Sud PACA. Source admin_express COG carto 2022';


--
-- Name: epci; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.epci (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    code_siren character varying(9),
    nom character varying(230),
    nature character varying(150)
);


ALTER TABLE admin_express.epci OWNER TO admin;

--
-- Name: TABLE epci; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.epci IS 'EPCI des départements 04 et 06 et périphérie. Source admin_express COG carto 2022';


--
-- Name: qgis_projects; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.qgis_projects (
    name text NOT NULL,
    metadata jsonb,
    content bytea
);


ALTER TABLE admin_express.qgis_projects OWNER TO admin;

--
-- Name: region; Type: TABLE; Schema: admin_express; Owner: admin
--

CREATE TABLE admin_express.region (
    id character varying NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    nom_m character varying(35),
    nom character varying(35),
    insee_reg character varying(2)
);


ALTER TABLE admin_express.region OWNER TO admin;

--
-- Name: TABLE region; Type: COMMENT; Schema: admin_express; Owner: admin
--

COMMENT ON TABLE admin_express.region IS 'Région Sud PACA. Source admin_express COG carto 2022';


--
-- Name: chflieu_commune chflieu_commune_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.chflieu_commune
    ADD CONSTRAINT chflieu_commune_pkey PRIMARY KEY (id);


--
-- Name: commune_associee_ou_deleguee commune_associee_ou_deleguee_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune_associee_ou_deleguee
    ADD CONSTRAINT commune_associee_ou_deleguee_pkey PRIMARY KEY (id);


--
-- Name: commune commune_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune
    ADD CONSTRAINT commune_pkey PRIMARY KEY (id);


--
-- Name: departement departement_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.departement
    ADD CONSTRAINT departement_pkey PRIMARY KEY (id);


--
-- Name: epci epci_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.epci
    ADD CONSTRAINT epci_pkey PRIMARY KEY (id);


--
-- Name: qgis_projects qgis_projects_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.qgis_projects
    ADD CONSTRAINT qgis_projects_pkey PRIMARY KEY (name);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: commune_insee_com_idx; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE UNIQUE INDEX commune_insee_com_idx ON admin_express.commune USING btree (insee_com);


--
-- Name: departement_insee_dep_idx; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE UNIQUE INDEX departement_insee_dep_idx ON admin_express.departement USING btree (insee_dep);


--
-- Name: epci_code_siren_idx; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE UNIQUE INDEX epci_code_siren_idx ON admin_express.epci USING btree (code_siren);


--
-- Name: region_insee_reg_idx; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE UNIQUE INDEX region_insee_reg_idx ON admin_express.region USING btree (insee_reg);


--
-- Name: sidx_chflieu_commune_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_chflieu_commune_geom ON admin_express.chflieu_commune USING gist (geom);


--
-- Name: sidx_commune_associee_ou_deleguee_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_commune_associee_ou_deleguee_geom ON admin_express.commune_associee_ou_deleguee USING gist (geom);


--
-- Name: sidx_commune_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_commune_geom ON admin_express.commune USING gist (geom);


--
-- Name: sidx_departement_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_departement_geom ON admin_express.departement USING gist (geom);


--
-- Name: sidx_epci_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_epci_geom ON admin_express.epci USING gist (geom);


--
-- Name: sidx_region_geom; Type: INDEX; Schema: admin_express; Owner: admin
--

CREATE INDEX sidx_region_geom ON admin_express.region USING gist (geom);


--
-- Name: chflieu_commune chflieu_commune_fk; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.chflieu_commune
    ADD CONSTRAINT chflieu_commune_fk FOREIGN KEY (id_com) REFERENCES admin_express.commune(id);


--
-- Name: commune_associee_ou_deleguee commune_associee_ou_deleguee_insee_com_fkey; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune_associee_ou_deleguee
    ADD CONSTRAINT commune_associee_ou_deleguee_insee_com_fkey FOREIGN KEY (insee_com) REFERENCES admin_express.commune(insee_com);


--
-- Name: commune commune_insee_dep_fkey; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune
    ADD CONSTRAINT commune_insee_dep_fkey FOREIGN KEY (insee_dep) REFERENCES admin_express.departement(insee_dep);


--
-- Name: commune commune_insee_reg_fkey; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune
    ADD CONSTRAINT commune_insee_reg_fkey FOREIGN KEY (insee_reg) REFERENCES admin_express.region(insee_reg);


--
-- Name: commune commune_siren_epci_fkey; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.commune
    ADD CONSTRAINT commune_siren_epci_fkey FOREIGN KEY (siren_epci) REFERENCES admin_express.epci(code_siren);


--
-- Name: departement departement_insee_reg_fkey; Type: FK CONSTRAINT; Schema: admin_express; Owner: admin
--

ALTER TABLE ONLY admin_express.departement
    ADD CONSTRAINT departement_insee_reg_fkey FOREIGN KEY (insee_reg) REFERENCES admin_express.region(insee_reg);


--
-- Name: SCHEMA admin_express; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA admin_express TO PUBLIC;


--
-- Name: TABLE chflieu_commune; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.chflieu_commune TO PUBLIC;


--
-- Name: TABLE commune; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.commune TO PUBLIC;


--
-- Name: TABLE commune_associee_ou_deleguee; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.commune_associee_ou_deleguee TO PUBLIC;


--
-- Name: TABLE departement; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.departement TO PUBLIC;


--
-- Name: TABLE epci; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.epci TO PUBLIC;


--
-- Name: TABLE qgis_projects; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.qgis_projects TO PUBLIC;


--
-- Name: TABLE region; Type: ACL; Schema: admin_express; Owner: admin
--

GRANT SELECT ON TABLE admin_express.region TO PUBLIC;


--
-- PostgreSQL database dump complete
--

