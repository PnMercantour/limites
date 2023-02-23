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
-- Name: inpn; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA inpn;


ALTER SCHEMA inpn OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: patch; Type: TABLE; Schema: inpn; Owner: postgres
--

CREATE TABLE inpn.patch (
    geom public.geometry(Polygon,2154)
);


ALTER TABLE inpn.patch OWNER TO postgres;

--
-- Name: pn; Type: TABLE; Schema: inpn; Owner: admin
--

CREATE TABLE inpn.pn (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id_local character varying(15),
    ppn_asso character varying(15),
    code_r_enp character varying(5),
    nom_site character varying(254),
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying(254),
    surf_off double precision,
    acte_deb character varying(50),
    acte_fin character varying(50),
    gest_site character varying(100),
    operateur character varying(50),
    "precision" character varying(2),
    src_geom character varying(100),
    src_annee character varying(4),
    marin character varying(1),
    p1_nature character varying(1),
    p2_culture character varying(1),
    p3_paysage character varying(1),
    p4_geologi character varying(1),
    p5_speleo character varying(1),
    p6_archeo character varying(1),
    p7_paleob character varying(1),
    p8_anthrop character varying(1),
    p9_science character varying(1),
    p10_public character varying(1),
    p11_dd character varying(1),
    p12_autre character varying(1),
    id_mnhn character varying(30)
);


ALTER TABLE inpn.pn OWNER TO admin;

--
-- Name: TABLE pn; Type: COMMENT; Schema: inpn; Owner: admin
--

COMMENT ON TABLE inpn.pn IS 'Parcs nationaux de métropole, INPN 2023-02';


--
-- Name: pn_id_seq1; Type: SEQUENCE; Schema: inpn; Owner: admin
--

CREATE SEQUENCE inpn.pn_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inpn.pn_id_seq1 OWNER TO admin;

--
-- Name: pn_id_seq1; Type: SEQUENCE OWNED BY; Schema: inpn; Owner: admin
--

ALTER SEQUENCE inpn.pn_id_seq1 OWNED BY inpn.pn.id;


--
-- Name: pnr; Type: TABLE; Schema: inpn; Owner: admin
--

CREATE TABLE inpn.pnr (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    id_mnhn character varying(30),
    id_local character varying(15),
    precis character varying(2),
    src_geom character varying(100),
    src_annee character varying(4),
    modif_geo date,
    nom_site character varying(254),
    surf_off character varying(254),
    gest_site character varying(254),
    date_crea date,
    modif_adm date,
    url_fiche character varying(254),
    marin character varying(254),
    p1_nature character varying(254),
    p2_culture character varying(254),
    p3_paysage character varying(254),
    p4_geologi character varying(254),
    p5_speleo character varying(1),
    p6_archeo character varying(1),
    p7_paleob character varying(1),
    p8_anthrop character varying(1),
    p9_science character varying(1),
    p10_public character varying(254),
    p11_dd character varying(254),
    operateur character varying(254),
    acte_deb character varying(50),
    objectid bigint,
    acte_fin character varying(50),
    "precision" character varying(2),
    p12_autre character varying(1)
);


ALTER TABLE inpn.pnr OWNER TO admin;

--
-- Name: TABLE pnr; Type: COMMENT; Schema: inpn; Owner: admin
--

COMMENT ON TABLE inpn.pnr IS 'Parcs naturels régionaux de la région Sud PACA, INPN 2023-02';


--
-- Name: pnr_202302_id_seq; Type: SEQUENCE; Schema: inpn; Owner: admin
--

CREATE SEQUENCE inpn.pnr_202302_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inpn.pnr_202302_id_seq OWNER TO admin;

--
-- Name: pnr_202302_id_seq; Type: SEQUENCE OWNED BY; Schema: inpn; Owner: admin
--

ALTER SEQUENCE inpn.pnr_202302_id_seq OWNED BY inpn.pnr.id;


--
-- Name: qgis_projects; Type: TABLE; Schema: inpn; Owner: admin
--

CREATE TABLE inpn.qgis_projects (
    name text NOT NULL,
    metadata jsonb,
    content bytea
);


ALTER TABLE inpn.qgis_projects OWNER TO admin;

--
-- Name: TABLE qgis_projects; Type: COMMENT; Schema: inpn; Owner: admin
--

COMMENT ON TABLE inpn.qgis_projects IS 'Projets QGIS';


--
-- Name: rnr; Type: TABLE; Schema: inpn; Owner: admin
--

CREATE TABLE inpn.rnr (
    id integer NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    objectid bigint,
    id_local character varying(15),
    nom_site character varying(254),
    date_crea date,
    modif_adm date,
    modif_geo date,
    url_fiche character varying(254),
    surf_off double precision,
    acte_deb character varying(50),
    acte_fin character varying(50),
    gest_site character varying(100),
    operateur character varying(50),
    "precision" character varying(2),
    src_geom character varying(100),
    src_annee character varying(4),
    marin character varying(1),
    p1_nature character varying(1),
    p2_culture character varying(1),
    p3_paysage character varying(1),
    p4_geologi character varying(1),
    p5_speleo character varying(1),
    p6_archeo character varying(1),
    p7_paleob character varying(1),
    p8_anthrop character varying(1),
    p9_science character varying(1),
    p10_public character varying(1),
    p11_dd character varying(1),
    p12_autre character varying(1),
    id_mnhn character varying(30)
);


ALTER TABLE inpn.rnr OWNER TO admin;

--
-- Name: TABLE rnr; Type: COMMENT; Schema: inpn; Owner: admin
--

COMMENT ON TABLE inpn.rnr IS 'Réserves naturelles régionales de la région Sud PACA, INPN 2023-02';


--
-- Name: rnr_202302_id_seq; Type: SEQUENCE; Schema: inpn; Owner: admin
--

CREATE SEQUENCE inpn.rnr_202302_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE inpn.rnr_202302_id_seq OWNER TO admin;

--
-- Name: rnr_202302_id_seq; Type: SEQUENCE OWNED BY; Schema: inpn; Owner: admin
--

ALTER SEQUENCE inpn.rnr_202302_id_seq OWNED BY inpn.rnr.id;


--
-- Name: pn id; Type: DEFAULT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.pn ALTER COLUMN id SET DEFAULT nextval('inpn.pn_id_seq1'::regclass);


--
-- Name: pnr id; Type: DEFAULT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.pnr ALTER COLUMN id SET DEFAULT nextval('inpn.pnr_202302_id_seq'::regclass);


--
-- Name: rnr id; Type: DEFAULT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.rnr ALTER COLUMN id SET DEFAULT nextval('inpn.rnr_202302_id_seq'::regclass);


--
-- Name: pn pn_pkey1; Type: CONSTRAINT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.pn
    ADD CONSTRAINT pn_pkey1 PRIMARY KEY (id);


--
-- Name: pnr pnr_202302_pkey; Type: CONSTRAINT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.pnr
    ADD CONSTRAINT pnr_202302_pkey PRIMARY KEY (id);


--
-- Name: qgis_projects qgis_projects_pkey; Type: CONSTRAINT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.qgis_projects
    ADD CONSTRAINT qgis_projects_pkey PRIMARY KEY (name);


--
-- Name: rnr rnr_202302_pkey; Type: CONSTRAINT; Schema: inpn; Owner: admin
--

ALTER TABLE ONLY inpn.rnr
    ADD CONSTRAINT rnr_202302_pkey PRIMARY KEY (id);


--
-- Name: pnr_202302_geom_idx; Type: INDEX; Schema: inpn; Owner: admin
--

CREATE INDEX pnr_202302_geom_idx ON inpn.pnr USING gist (geom);


--
-- Name: sidx_rnr_202302_geom; Type: INDEX; Schema: inpn; Owner: admin
--

CREATE INDEX sidx_rnr_202302_geom ON inpn.rnr USING gist (geom);


--
-- Name: SCHEMA inpn; Type: ACL; Schema: -; Owner: admin
--

GRANT USAGE ON SCHEMA inpn TO PUBLIC;


--
-- Name: TABLE patch; Type: ACL; Schema: inpn; Owner: postgres
--

GRANT SELECT ON TABLE inpn.patch TO PUBLIC;


--
-- Name: TABLE pn; Type: ACL; Schema: inpn; Owner: admin
--

GRANT SELECT ON TABLE inpn.pn TO PUBLIC;


--
-- Name: TABLE pnr; Type: ACL; Schema: inpn; Owner: admin
--

GRANT SELECT ON TABLE inpn.pnr TO PUBLIC;


--
-- Name: TABLE qgis_projects; Type: ACL; Schema: inpn; Owner: admin
--

GRANT SELECT ON TABLE inpn.qgis_projects TO PUBLIC;


--
-- Name: TABLE rnr; Type: ACL; Schema: inpn; Owner: admin
--

GRANT SELECT ON TABLE inpn.rnr TO PUBLIC;


--
-- PostgreSQL database dump complete
--

