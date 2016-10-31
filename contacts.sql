--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.4
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.groups_contacts DROP CONSTRAINT groups_contacts_group_id_fkey;
ALTER TABLE ONLY public.groups_contacts DROP CONSTRAINT groups_contacts_contact_id_fkey;
ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_pkey;
ALTER TABLE ONLY public.groups_contacts DROP CONSTRAINT groups_contacts_pkey;
ALTER TABLE ONLY public.contacts DROP CONSTRAINT contacts_pkey;
ALTER TABLE public.groups ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.contacts ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.groups_id_seq;
DROP TABLE public.groups_contacts;
DROP TABLE public.groups;
DROP SEQUENCE public.contacts_id_seq;
DROP TABLE public.contacts;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: contacts; Type: TABLE; Schema: public; Owner: mrchriss
--

CREATE TABLE contacts (
    id integer NOT NULL,
    first_name character varying(35) NOT NULL,
    last_name character varying(35) NOT NULL,
    email character varying(40) NOT NULL,
    number character varying(35) NOT NULL
);


ALTER TABLE contacts OWNER TO mrchriss;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: mrchriss
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE contacts_id_seq OWNER TO mrchriss;

--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mrchriss
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: mrchriss
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying(40) NOT NULL
);


ALTER TABLE groups OWNER TO mrchriss;

--
-- Name: groups_contacts; Type: TABLE; Schema: public; Owner: mrchriss
--

CREATE TABLE groups_contacts (
    group_id integer NOT NULL,
    contact_id integer NOT NULL
);


ALTER TABLE groups_contacts OWNER TO mrchriss;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: mrchriss
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE groups_id_seq OWNER TO mrchriss;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mrchriss
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: mrchriss
--



--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mrchriss
--

SELECT pg_catalog.setval('contacts_id_seq', 34, true);


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: mrchriss
--



--
-- Data for Name: groups_contacts; Type: TABLE DATA; Schema: public; Owner: mrchriss
--



--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mrchriss
--

SELECT pg_catalog.setval('groups_id_seq', 13, true);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: groups_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY groups_contacts
    ADD CONSTRAINT groups_contacts_pkey PRIMARY KEY (group_id, contact_id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: groups_contacts_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY groups_contacts
    ADD CONSTRAINT groups_contacts_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES contacts(id);


--
-- Name: groups_contacts_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mrchriss
--

ALTER TABLE ONLY groups_contacts
    ADD CONSTRAINT groups_contacts_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

