--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: p_group; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE p_group (
    id integer NOT NULL,
    name character varying NOT NULL,
    project character varying NOT NULL,
    meets_on_day character varying,
    meets_at_time time without time zone
);


ALTER TABLE public.p_group OWNER TO "EdbertsApp";

--
-- Name: p_group_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE p_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.p_group_id_seq OWNER TO "EdbertsApp";

--
-- Name: p_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE p_group_id_seq OWNED BY p_group.id;


--
-- Name: person; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE person (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    birthday date,
    home_number character varying,
    mobile_number character varying,
    email_address character varying,
    gender character varying,
    nationality character varying
);


ALTER TABLE public.person OWNER TO "EdbertsApp";

--
-- Name: person_group_relation; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE person_group_relation (
    id integer NOT NULL,
    person bigint NOT NULL,
    "group" bigint NOT NULL
);


ALTER TABLE public.person_group_relation OWNER TO "EdbertsApp";

--
-- Name: person_group_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE person_group_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_group_relation_id_seq OWNER TO "EdbertsApp";

--
-- Name: person_group_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE person_group_relation_id_seq OWNED BY person_group_relation.id;


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_id_seq OWNER TO "EdbertsApp";

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE person_id_seq OWNED BY person.id;


--
-- Name: person_qual_relation; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE person_qual_relation (
    id integer NOT NULL,
    person bigint NOT NULL,
    qual bigint NOT NULL
);


ALTER TABLE public.person_qual_relation OWNER TO "EdbertsApp";

--
-- Name: person_qual_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE person_qual_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_qual_relation_id_seq OWNER TO "EdbertsApp";

--
-- Name: person_qual_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE person_qual_relation_id_seq OWNED BY person_qual_relation.id;


--
-- Name: qual; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE qual (
    id integer NOT NULL,
    name character varying NOT NULL,
    details character varying
);


ALTER TABLE public.qual OWNER TO "EdbertsApp";

--
-- Name: qual_group_relation; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE qual_group_relation (
    id integer NOT NULL,
    qual bigint NOT NULL,
    "group" bigint NOT NULL
);


ALTER TABLE public.qual_group_relation OWNER TO "EdbertsApp";

--
-- Name: qual_group_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE qual_group_relation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qual_group_relation_id_seq OWNER TO "EdbertsApp";

--
-- Name: qual_group_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE qual_group_relation_id_seq OWNED BY qual_group_relation.id;


--
-- Name: qual_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE qual_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qual_id_seq OWNER TO "EdbertsApp";

--
-- Name: qual_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE qual_id_seq OWNED BY qual.id;


--
-- Name: register; Type: TABLE; Schema: public; Owner: EdbertsApp; Tablespace: 
--

CREATE TABLE register (
    id integer NOT NULL,
    date date NOT NULL,
    "group" bigint NOT NULL,
    people_present character varying NOT NULL,
    people_not_present character varying NOT NULL
);


ALTER TABLE public.register OWNER TO "EdbertsApp";

--
-- Name: register_id_seq; Type: SEQUENCE; Schema: public; Owner: EdbertsApp
--

CREATE SEQUENCE register_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.register_id_seq OWNER TO "EdbertsApp";

--
-- Name: register_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: EdbertsApp
--

ALTER SEQUENCE register_id_seq OWNED BY register.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY p_group ALTER COLUMN id SET DEFAULT nextval('p_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person ALTER COLUMN id SET DEFAULT nextval('person_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_group_relation ALTER COLUMN id SET DEFAULT nextval('person_group_relation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_qual_relation ALTER COLUMN id SET DEFAULT nextval('person_qual_relation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY qual ALTER COLUMN id SET DEFAULT nextval('qual_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY qual_group_relation ALTER COLUMN id SET DEFAULT nextval('qual_group_relation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY register ALTER COLUMN id SET DEFAULT nextval('register_id_seq'::regclass);


--
-- Data for Name: p_group; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY p_group (id, name, project, meets_on_day, meets_at_time) FROM stdin;
1	Sumo Wrestling 	The Fold	Tuesday	12:20:00
2	Food Potting Alliance	The Fold	Wednesday	04:15:26
9	Phone Running Clique	High Lanes	Friday	09:13:06
12	Exam Pruning Union	High Lanes	Saturday	10:11:36
13	Theory Leading Family	High Lanes	Wednesday	18:36:06
16	Theory Pruning Company	High Lanes	Monday	16:25:00
19	Fish Gurning Family	The Fold	Wednesday	15:44:38
21	Paper Fighting Club	The Fold	Wednesday	19:26:46
22	Fish Growing Association	High Lanes	Thursday	21:33:13
24	Army Reading Club	High Lanes	Saturday	12:49:10
25	Computer Eating Confederation	The Fold	Monday	18:00:08
34	Elderly Driving Federation	High Lanes	Friday	13:20:56
35	Fish Ogling Band	High Lanes	Sunday	15:56:57
37	Paper Drinking Federation	The Fold	Sunday	02:52:46
41	Computer Loving Federation	High Lanes	Wednesday	02:39:03
43	Computer Relishing Association	High Lanes	Tuesday	11:04:40
45	Road Running Congress	The Fold	Thursday	20:47:14
46	Middle-aged Shooting Bunch	High Lanes	Thursday	01:03:46
48	Dog Leading Fraternity	High Lanes	Tuesday	13:35:41
51	Power Mating Federation	The Fold	Wednesday	19:51:57
52	Theory Writing Confederation	High Lanes	Monday	22:46:35
53	Nature Mating Family	The Fold	Friday	05:37:23
55	Army Mating Syndicate	The Fold	Thursday	12:15:30
59	Elderly Licking Circle	The Fold	Friday	21:21:52
60	Story Relishing Crew	The Fold	Thursday	10:18:33
62	Office Writing Crew	The Fold	Friday	21:00:43
65	Language Mating Congress	High Lanes	Thursday	04:43:27
66	Safety Arranging Sect	High Lanes	Monday	20:35:02
70	Fork Jumping Band	The Fold	Saturday	02:47:16
72	Nation Shooting Federation	The Fold	Monday	15:45:43
73	Young Eating Confederacy	The Fold	Thursday	01:59:08
74	Language Reading Club	High Lanes	Saturday	22:47:57
76	Power Running Outfit	The Fold	Thursday	01:18:05
78	Spoon Loving Union	The Fold	Wednesday	12:09:44
80	Night Running Bunch	The Fold	Thursday	08:03:45
81	Office Potting Crew	The Fold	Thursday	08:14:48
82	Football Driving Society	The Fold	Monday	00:22:43
84	Truth Arranging Crew	The Fold	Saturday	07:45:08
89	Young Leading Congress	High Lanes	Thursday	00:58:29
90	Paper Ogling Outfit	High Lanes	Monday	07:17:25
68	Fish Loving Sect	The Fold	Monday	05:18:28
96	Football Gurning Syndicate	The Fold	Wednesday	08:52:26
98	Young Drinking Alliance	High Lanes	Monday	07:19:36
99	Flower Shooting Association	High Lanes	Thursday	17:48:27
103	Pokemon Battling Group	High Lanes	Monday	12:00:00
\.


--
-- Name: p_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('p_group_id_seq', 103, true);


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY person (id, first_name, last_name, birthday, home_number, mobile_number, email_address, gender, nationality) FROM stdin;
1	Uriah	Mcpherson	2006-04-11	(0111) 431 4758	0500 198946	convallis@nisi.com	Male	Black Caribbean
2	Fletcher	Glenn	1951-07-17	0800 357886	070 8143 0112	odio.Aliquam.vulputate@eratVivamusnisi.co.uk	Male	Black African
3	Bernard	Camacho	1987-01-06	07624 724285	0845 46 47	ipsum.non@tellusSuspendisse.ca	Male	Chinese
4	Odysseus	Gilbert	2001-03-14	(01904) 095255	(0114) 349 6416	dui@Duisdignissimtempor.ca	Male	Black African
5	Neil	Farrell	1990-01-21	07624 097004	0800 681063	non@Aliquam.ca	Male	Other
6	Lamar	Delgado	1951-05-25	(026) 4096 0333	0800 851039	nisi.sem.semper@mattisIntegereu.edu	Male	Black Caribbean
7	Caesar	Howe	1992-04-05	(01108) 853014	076 4243 6625	est@at.net	Male	Chinese
8	Dylan	Hines	1995-10-22	(0114) 564 9569	07045 867945	pede.Praesent.eu@in.net	Male	White other
9	Uriel	Jenkins	1986-09-16	0800 115888	07624 116503	vehicula.risus.Nulla@enimnectempus.org	Male	Black other
10	Geoffrey	Wells	1993-04-09	0845 46 46	07746 722848	Donec.egestas.Aliquam@vel.edu	Male	Other
11	Isaiah	Obrien	1994-12-18	0800 175105	(016977) 1472	dictum.placerat@tempus.net	Male	White other
12	Hall	Cannon	1953-08-30	(016977) 6228	(01556) 96985	sit.amet@molestieorci.ca	Male	Chinese
13	Quinlan	Bryan	1998-06-02	070 6945 1518	(0114) 690 6876	diam.lorem@euaugue.edu	Male	Other
14	Kibo	Gilmore	1993-06-29	07144 278753	0920 860 3391	Mauris.blandit.enim@sit.org	Male	Black African
15	Shad	Baxter	1990-10-19	0800 1111	(0115) 627 9890	Aliquam.tincidunt.nunc@a.org	Male	Black African
16	Tobias	Bonner	1992-11-13	(0101) 654 6197	0800 077 4291	Morbi@imperdiet.co.uk	Male	White British
17	Ignatius	Whitney	1967-06-15	0800 929 3406	(016977) 4793	mollis.Duis.sit@ullamcorperviverraMaecenas.com	Male	White other
18	Jameson	Hall	1951-05-09	0500 318832	0500 398263	augue@ornareFuscemollis.edu	Male	Black African
19	Trevor	Petersen	1971-11-17	0931 200 7988	(016977) 5696	elit.pharetra@Cumsociisnatoque.co.uk	Male	Black other
20	Alec	Glover	1955-05-21	0845 46 41	(016977) 7198	lectus.Cum.sociis@sapien.com	Male	White other
21	Fuller	Nichols	1955-01-06	07624 530255	0845 46 42	mollis.non@ultricesposuerecubilia.edu	Male	Other
22	Jameson	Riggs	1976-11-06	0305 621 2373	0800 312678	mollis.Integer@quamCurabiturvel.org	Male	Other
23	Howard	Mathews	1961-07-23	0800 1111	070 1971 3609	est.arcu.ac@dignissimlacusAliquam.com	Male	Black African
24	Hunter	Pope	1974-11-22	0929 987 0201	0800 754874	adipiscing@aneque.edu	Male	White other
25	Garrison	Gillespie	1991-12-30	(016977) 2194	0852 715 8736	ipsum@sedconsequat.org	Male	White other
26	Walker	Ashley	1969-10-31	0972 086 5957	(012540) 60192	odio.Phasellus.at@rutrum.edu	Male	Black African
27	Ezekiel	Wolf	2009-08-08	055 7079 9804	055 6132 5032	volutpat.Nulla.facilisis@dolorFusce.org	Male	Chinese
28	Ulric	Parrish	1997-08-15	(01440) 802709	0800 381233	Curabitur.dictum.Phasellus@egestasSedpharetra.edu	Male	White other
29	Vance	Kinney	1990-08-11	0845 46 43	07624 494347	placerat.orci.lacus@ullamcorpermagna.edu	Male	Chinese
30	Caesar	Craft	1991-09-21	(01777) 261957	(01523) 129564	tellus@egestasnunc.net	Male	Chinese
31	Davis	Gill	2005-04-06	(0181) 857 9544	056 5205 2620	et@Morbisitamet.com	Male	Black African
32	Ronan	Reeves	1975-08-16	076 8405 4872	0800 773 1216	leo.Cras@semperegestas.com	Male	Other
33	Sebastian	Salinas	1960-06-05	(016977) 9292	0943 031 3714	egestas.rhoncus.Proin@ultricesposuerecubilia.edu	Male	White British
34	Fulton	Marquez	1965-11-21	056 2999 0227	070 4293 5485	sed@dictum.com	Male	Chinese
35	Sean	Estes	1988-08-06	0500 623635	0945 800 8096	feugiat.nec.diam@Nullamlobortisquam.com	Male	Black Caribbean
36	Brady	Osborn	2011-02-13	070 3890 8677	(0131) 736 6078	diam@lectus.net	Male	White other
37	Honorato	Mooney	1970-05-15	055 2027 0702	0800 090 9397	odio.vel@Nam.ca	Male	White British
38	Griffith	Anthony	1962-05-27	056 6550 1188	(01082) 521628	ut.molestie@ornareInfaucibus.org	Male	Black African
39	Stone	Oneil	1977-04-23	(024) 8066 0843	0800 1111	eleifend.nec.malesuada@neque.net	Male	Black Caribbean
40	Jameson	Tanner	2003-09-07	(0111) 116 2107	0500 961265	aliquet.nec@consequatnec.edu	Male	White British
41	Clayton	Middleton	2001-10-27	07694 633360	(0131) 253 1085	felis@velit.co.uk	Male	Other
42	Drew	Noel	1955-11-07	0800 224 4161	0814 525 3271	non.leo@enim.co.uk	Male	White other
43	Amery	Frost	1956-07-27	0368 314 5668	(021) 5663 9925	sem.Pellentesque@etnetuset.com	Male	Black Caribbean
44	Dustin	Gordon	1989-10-23	0800 055 3555	(010904) 20540	mollis.dui.in@turpisegestas.ca	Male	White other
45	Bernard	Randall	1953-07-04	0354 986 3911	(01778) 963087	velit@a.com	Male	White other
46	Axel	Mcclain	1967-03-28	0845 46 45	(0111) 346 3399	mollis.Duis@justo.com	Male	White British
47	Kuame	Nolan	2010-04-26	0837 691 0452	055 5666 8889	euismod@est.com	Male	Black Caribbean
48	Zeus	Melton	1968-02-06	0500 862179	0931 703 7614	faucibus.id@liberoat.co.uk	Male	White British
49	Denton	Emerson	1974-07-26	(01236) 24026	0800 160597	in.tempus.eu@Seddiam.com	Male	Chinese
50	Wing	Cherry	1982-05-20	(01737) 90641	(0131) 365 4351	adipiscing.ligula.Aenean@massarutrum.org	Male	Black other
51	Howard	Stewart	1970-12-31	(021) 2421 9406	0500 262186	In@velit.edu	Male	White other
52	Hamish	Flowers	1965-06-18	(017512) 28395	(0113) 043 0425	dapibus.gravida.Aliquam@gravida.org	Male	White British
53	Kermit	Trujillo	1981-10-12	076 9037 9079	(015882) 58622	sem@odio.co.uk	Male	Black other
54	Buckminster	Wells	1989-07-29	076 6466 0186	(0113) 127 6979	imperdiet.erat@ascelerisque.edu	Male	Other
55	Magee	Dickson	1952-10-13	056 4071 0582	(019078) 43210	est.ac.mattis@orciadipiscing.net	Male	Black Caribbean
56	Tyler	Bailey	2006-03-07	056 7116 0881	0832 434 3446	Phasellus@IntegermollisInteger.ca	Male	Black African
57	Giacomo	Carroll	1991-03-08	0302 315 6151	(014526) 47185	Integer.tincidunt.aliquam@eratEtiamvestibulum.net	Male	Black Caribbean
58	Channing	Boyer	1999-12-07	(025) 4903 0782	056 3810 5679	placerat.eget.venenatis@semNullainterdum.edu	Male	Black Caribbean
59	Declan	Webb	1986-05-12	(0111) 033 2408	(010240) 35655	ligula.eu.enim@orci.edu	Male	White British
60	Mufutau	Lowery	1976-06-25	(01282) 76435	076 6324 4948	eget@Cumsociisnatoque.co.uk	Male	White other
61	Colin	Sanford	1963-09-04	055 9707 0385	(0141) 254 1187	pede.Suspendisse@Vivamus.org	Male	Black African
62	Grady	Guthrie	1971-11-05	(028) 5196 0968	070 3031 7550	Curabitur.dictum@Namligula.co.uk	Male	Black African
63	Drew	Kirkland	1966-12-10	(01597) 36169	(016977) 1299	Donec.fringilla@aliquamiaculis.co.uk	Male	White British
64	Ray	Hopkins	1978-02-19	0337 460 1812	0848 978 4811	eget@ut.ca	Male	Black other
65	Beau	Kline	1979-02-24	(0181) 001 6685	(016977) 5217	ante@Integertincidunt.ca	Male	White British
66	Chadwick	Yates	1964-12-19	0899 295 2299	076 6715 4385	neque@Nulla.edu	Male	White other
67	Nigel	Valdez	1955-01-01	055 6156 6775	055 4801 8553	interdum.Nunc@risus.org	Male	White other
68	Ralph	Bridges	1983-05-13	(01017) 867504	(027) 4092 3259	mollis@Curae.com	Male	White other
69	Gray	Shields	1951-12-03	(0161) 832 2373	0500 362729	pede.Cras.vulputate@elit.org	Male	Black Caribbean
70	Ira	Madden	1978-07-20	056 9652 0511	070 4853 3854	Nulla@sit.co.uk	Male	Other
71	Ray	Mcintosh	1955-07-15	0800 1111	0800 1111	cursus.in@tellus.net	Male	Black African
72	Gavin	Jennings	2012-05-02	(01986) 05053	(0113) 458 6593	eget@lacusCrasinterdum.co.uk	Male	White British
73	Clark	Nguyen	1955-05-01	055 0199 5829	076 7233 0236	Duis@arcu.com	Male	White British
74	Kevin	Shaw	2003-06-13	07624 433052	056 1718 5462	montes@fringilla.edu	Male	Other
75	Jacob	Richmond	1972-10-17	(01319) 16587	(024) 9697 9678	magna@acorciUt.net	Male	White British
76	Brennan	Walker	1963-11-13	(0171) 633 0027	0800 714 5719	nunc.sit.amet@Nam.ca	Male	Black Caribbean
77	Paki	Carlson	1954-07-03	(025) 7543 7331	0500 519418	posuere@eratVivamusnisi.ca	Male	White British
78	Ali	Meyer	1988-10-11	0800 070 6735	0800 448784	dictum.cursus@adipiscingelit.edu	Male	White other
79	Tad	Rosa	1960-09-16	0308 201 4814	(015568) 53271	sollicitudin@Craseu.co.uk	Male	Black other
80	Gil	Koch	1958-05-25	076 3618 3516	0500 601045	enim.nec.tempus@ornareliberoat.ca	Male	Black other
81	Judah	Thornton	1978-04-25	0800 219 4901	(01874) 99435	enim@Donec.org	Male	Black Caribbean
82	Upton	Middleton	1968-10-16	0800 497 9550	0500 330030	sagittis.semper@ornaresagittisfelis.org	Male	Black Caribbean
83	Dennis	Yates	1998-09-14	0947 967 0735	(0191) 220 1066	bibendum.sed.est@semsemper.ca	Male	White other
84	Dieter	Conner	2001-08-06	070 5146 2687	076 3412 8087	luctus@loremsit.ca	Male	White other
85	Hilel	Solomon	1959-05-26	0800 1111	07211 148114	diam.at.pretium@amet.co.uk	Male	Black Caribbean
86	Chadwick	May	2004-02-11	0800 637 5677	07624 171847	lacus.pede@nullaIn.com	Male	Black African
87	Jamal	Armstrong	1974-10-13	07624 257178	(01131) 79024	sodales@acorciUt.net	Male	Other
88	John	Pacheco	1995-09-03	056 0579 8871	(028) 8863 5123	urna@tellus.org	Male	Black Caribbean
89	Malachi	Cain	2012-01-03	0800 418196	0800 721417	non@dui.co.uk	Male	Other
90	Trevor	Houston	1977-10-12	(01691) 26460	0800 643 1712	velit.eget.laoreet@viverraDonec.edu	Male	Black other
91	Herrod	Reyes	1992-06-12	0500 628890	0800 1111	dapibus.gravida.Aliquam@facilisisnon.co.uk	Male	Black other
92	Myles	Howell	2004-10-25	(016977) 9696	(016977) 8393	nibh.lacinia@nec.net	Male	Black other
93	Honorato	Rutledge	1974-10-23	(01747) 52743	056 7352 2209	accumsan.interdum.libero@turpisegestas.edu	Male	Other
94	Rooney	Miranda	1983-02-18	(016977) 3149	070 6196 3118	nulla@Suspendissenon.net	Male	Chinese
95	Declan	Guy	2006-06-29	07511 433172	07624 188748	non@odiosagittis.net	Male	Black Caribbean
96	Guy	Richards	1950-11-16	070 9130 3727	07624 316333	est.ac.facilisis@turpisnec.co.uk	Male	White other
97	Lance	Nieves	2001-12-29	0500 899070	(017031) 00702	malesuada.fames@purusmauris.org	Male	Chinese
98	Amal	Tillman	1983-08-02	0845 46 41	0952 953 3879	vitae@eget.edu	Male	Other
99	Dalton	Petty	1995-12-08	0800 238 8182	(016977) 1975	ridiculus@tacitisociosqu.ca	Male	Black African
100	Hamilton	Reyes	1959-11-24	0997 906 0972	070 7346 2067	dolor.vitae.dolor@lobortis.co.uk	Male	Black African
101	Marah	Foreman	2010-05-04	076 2345 9993	0845 46 48	Quisque.fringilla.euismod@ipsumSuspendisse.com	Female	White British
102	Wyoming	Hickman	1964-01-18	07624 802060	07750 076629	habitant@nislNulla.ca	Female	Black Caribbean
103	Elizabeth	Landry	1997-11-04	0800 525221	0900 219 1344	Aliquam.gravida.mauris@velit.com	Female	White British
104	Tatyana	Blackburn	1969-02-13	(01841) 29359	070 3086 3667	sed.sem.egestas@natoquepenatibuset.ca	Female	Black African
105	Emma	Decker	1990-12-01	070 7462 5550	(01557) 063088	lacinia.at.iaculis@sempertellus.ca	Female	Black other
106	Fay	Roy	1962-02-07	0500 540655	0877 689 8757	tristique.ac@dolorDonec.edu	Female	White British
107	Stella	Barrera	1975-12-14	(0151) 667 6577	(0117) 879 7598	mus.Donec@Sed.co.uk	Female	Black other
108	Noelani	Williamson	1963-03-31	0955 768 9131	0800 1111	rhoncus.id@congueIn.net	Female	Black African
109	Aubrey	Blanchard	1951-06-20	0845 46 41	0800 423 4754	sit.amet@augueeu.co.uk	Female	Black other
110	Ainsley	Mcbride	1996-12-10	07624 335332	(0101) 970 5065	Integer.id.magna@liberoet.net	Female	Other
111	Zephr	Franco	1969-10-03	07887 175259	(01067) 29260	ac@Morbiquis.org	Female	White British
112	Aurora	Whitfield	1983-03-17	0800 205 8059	(016977) 6000	accumsan.convallis.ante@enim.co.uk	Female	Black Caribbean
113	Cheryl	Hendricks	1971-07-20	(015983) 56992	0952 880 0999	Nam.consequat@purus.edu	Female	Black Caribbean
114	Brenda	Reed	1962-10-31	0800 998 2060	0800 959697	ligula@fermentum.org	Female	Other
115	Lesley	Newton	1960-12-16	07035 647669	(01194) 212824	magnis.dis.parturient@eudolor.co.uk	Female	Black Caribbean
116	Pandora	Norris	1982-11-06	(0161) 836 4194	0892 549 1298	sem.consequat.nec@Curabiturdictum.com	Female	White other
117	Glenna	Ramos	1998-11-29	(0161) 392 3244	(01268) 163407	eget.magna.Suspendisse@molestie.ca	Female	Black Caribbean
118	Lacey	Pratt	2006-09-06	0309 463 2076	070 1295 1997	nec.imperdiet@Phasellus.edu	Female	White other
119	Harriet	Kelly	1953-04-24	0800 963828	076 8518 3501	Ut.sagittis.lobortis@erat.ca	Female	Black African
120	Pamela	Spencer	1955-11-29	0827 627 0422	07624 150355	eu.ultrices.sit@penatibusetmagnis.ca	Female	Black other
121	Jenna	Hernandez	1971-08-18	(0118) 916 9610	070 6636 3514	Nulla@metuseuerat.net	Female	White British
122	Sharon	Hurst	1982-02-23	0834 489 1401	0984 178 8403	purus@augue.co.uk	Female	Other
123	Kaitlin	Benson	1972-11-19	0800 034254	07624 309025	Fusce@utnisia.net	Female	Chinese
124	Colette	Gallegos	2005-01-25	0337 163 4321	(0115) 508 9584	posuere.vulputate.lacus@euismodacfermentum.edu	Female	Black other
125	Melissa	Foster	1954-10-08	0845 46 42	076 9939 5950	Donec@loremut.org	Female	White British
126	Aurelia	Wong	1982-09-25	(0181) 810 3270	(0161) 855 4483	in.lobortis@nisiMaurisnulla.ca	Female	White other
127	Lacey	Horton	1953-04-30	(0171) 706 8399	0382 535 8263	scelerisque.dui@penatibus.net	Female	Other
128	Basia	Horne	1978-07-02	0800 719 9630	(01011) 98517	sem.consequat@Duissit.edu	Female	White British
129	Basia	Norton	1953-07-06	070 7664 6199	(0111) 226 6009	nulla@eratvolutpat.co.uk	Female	Other
130	Kelsey	Mueller	1959-05-24	0800 813 8952	0845 46 47	ullamcorper@sit.ca	Female	Black other
131	Galena	Bright	1950-11-14	(01284) 126976	0914 667 6421	posuere.at@orcilacus.co.uk	Female	Other
132	Nadine	Montgomery	1988-01-01	07624 610563	0847 609 2131	tortor.Nunc.commodo@ultricesa.edu	Female	Black African
133	Barbara	Obrien	1991-11-23	07558 933598	(01676) 76044	eget.metus.eu@loremvehicula.net	Female	White British
134	Miranda	Clay	2000-08-20	(016977) 2515	(0181) 300 2064	Mauris.vel.turpis@adipiscingMaurismolestie.net	Female	White British
135	Shea	Velez	1959-05-25	055 1058 3508	0800 1111	tortor.Integer@Proinnislsem.org	Female	Chinese
136	Charde	Sheppard	1981-10-26	056 6129 4711	076 8622 3643	odio.Aliquam@ipsum.org	Female	Chinese
137	Alexis	Massey	1997-06-23	0845 46 49	07868 788927	vehicula.et@diam.edu	Female	Other
138	Karen	Sexton	1952-10-31	(028) 5354 9247	0800 1111	dui@placerat.com	Female	Chinese
139	Kerry	Gregory	1978-03-22	(0121) 711 5841	0800 189 0503	metus@euelitNulla.co.uk	Female	Other
140	Florence	Mcdowell	1979-12-26	07008 140022	0800 852 2388	eu.metus@mipede.com	Female	Black Caribbean
141	Hermione	Hyde	2010-01-30	0800 1111	056 5474 7012	eu.accumsan@nullaIntegervulputate.co.uk	Female	Black African
142	Amy	Baxter	1975-04-25	0845 46 43	0845 46 47	Maecenas@Nullam.com	Female	Black African
143	Cameron	Beach	2009-05-16	0940 644 2899	(0161) 781 1051	elit.dictum.eu@Proin.ca	Female	Other
144	Rhona	Wilcox	1985-09-27	055 7211 7780	(01879) 31691	inceptos.hymenaeos@Aeneanegestashendrerit.co.uk	Female	White British
145	Maxine	Casey	1981-08-22	(025) 2780 0796	0800 027 2682	aliquet@Aeneansedpede.co.uk	Female	Black African
146	Eleanor	Avery	1981-01-08	0328 312 0211	(016977) 3483	Etiam@nunc.edu	Female	Black African
147	Adele	Vaughan	1965-12-14	(025) 9964 1919	(017825) 76067	Cum.sociis@morbi.org	Female	White British
148	Dakota	Boone	1996-08-16	(022) 9899 2458	(0116) 469 1557	interdum@mitempor.co.uk	Female	White British
149	Rowan	Hays	1953-08-09	(0117) 353 1907	0800 1111	est.mollis@dapibusrutrum.net	Female	White British
150	Rhonda	Saunders	1951-03-14	0859 249 3108	055 7885 1074	ligula.tortor@sapienimperdiet.edu	Female	Chinese
151	Olivia	Powell	1965-01-19	0845 46 43	(022) 8216 3154	nec@adipiscingfringillaporttitor.org	Female	Black Caribbean
152	Quon	Hall	1969-09-27	055 4616 2733	(016977) 1874	dolor@inaliquetlobortis.ca	Female	White British
153	Melanie	Welch	2002-06-02	056 4286 5608	070 3817 8730	lacus@orci.edu	Female	Black other
154	Madaline	Meyers	1954-01-03	(0131) 823 1530	055 6522 9070	orci@sapienmolestieorci.co.uk	Female	Black African
155	Vera	Hubbard	1960-07-02	0500 504843	0351 378 4330	nibh.dolor@ullamcorpermagna.com	Female	White British
156	Mercedes	Sutton	1980-02-26	0800 1111	055 1067 2702	neque.pellentesque.massa@Phasellus.ca	Female	Black African
157	Nichole	Gay	1970-01-27	076 8691 5079	(0111) 856 3090	sed.sem.egestas@velit.com	Female	Black African
158	Ivana	Green	1955-11-27	056 2196 8300	(01857) 49487	tempus.mauris.erat@nunc.net	Female	White other
159	Camille	Spencer	1953-02-16	0800 806 5650	(016977) 6736	Aliquam@consequatenim.co.uk	Female	Black Caribbean
160	Alyssa	Wallace	1985-11-10	0800 185109	0396 539 5264	risus.Donec.nibh@dignissim.org	Female	Black African
161	Susan	Rutledge	1976-07-11	056 8132 2892	0985 039 4392	id.blandit@nec.com	Female	White other
162	Dahlia	Cline	1967-08-05	(01793) 00339	0800 318292	Proin.nisl.sem@porttitorerosnec.org	Female	White British
163	Barbara	Avila	1986-01-25	056 8484 9910	07624 444474	volutpat@egetlaoreet.org	Female	Other
164	MacKensie	Bell	1963-12-04	0845 46 40	0500 589950	arcu.vel.quam@feliseget.org	Female	Chinese
165	Aimee	Levy	2008-06-21	0800 533101	(028) 2899 7691	eu.turpis@sollicitudin.edu	Female	Black other
166	Kiayada	Barlow	1961-10-27	(018593) 88506	0845 46 47	sapien.molestie.orci@habitantmorbitristique.net	Female	Chinese
167	Vanna	Jenkins	1955-07-16	0800 377 2132	(016977) 0563	Etiam@eget.net	Female	Black other
168	Sloane	Cantu	1970-07-16	07624 082055	(012021) 61440	nisi.sem@nisi.ca	Female	Chinese
169	Azalia	Byrd	2000-01-23	(018373) 15171	076 8500 2325	consectetuer.euismod.est@Maecenasmifelis.co.uk	Female	Black Caribbean
170	Sierra	Haley	1992-05-05	(0141) 945 2140	056 8011 3688	semper.egestas.urna@Aeneansedpede.edu	Female	Chinese
171	Mollie	Decker	1959-05-07	(0114) 298 2791	056 6590 1811	dolor@nibhenimgravida.org	Female	Other
172	Octavia	Cross	2001-04-18	(016977) 7980	07624 031328	odio@suscipitnonummyFusce.ca	Female	White other
173	Karleigh	Mckinney	1959-09-08	(021) 5349 3833	0800 1111	Donec.nibh@interdum.ca	Female	Black Caribbean
174	Aurora	Schmidt	1988-09-04	0800 639 8923	(0161) 119 0000	egestas@arcu.edu	Female	Black Caribbean
175	Ivory	Francis	2005-08-28	(01488) 183586	076 1143 5373	dui.Fusce@hymenaeosMaurisut.net	Female	Other
176	Charity	Klein	1953-07-10	(015875) 18195	0862 204 9651	mauris@fermentum.edu	Female	Black Caribbean
177	Kyra	Odom	1953-12-09	0936 967 6339	055 1533 3317	libero.nec@Aliquamultrices.org	Female	Chinese
178	Beverly	Ingram	1951-04-18	0800 867137	(017015) 07321	primis.in@risusDonecegestas.edu	Female	Chinese
179	Genevieve	Butler	2001-11-19	056 9392 8216	(025) 4746 8910	ante@velmaurisInteger.net	Female	Chinese
180	Natalie	Haney	1979-07-07	07624 630286	0845 46 48	egestas.Aliquam@ullamcorper.edu	Female	Black African
181	Lysandra	Owens	1973-01-28	0818 802 0960	(01200) 82703	gravida@ornarelectus.org	Female	White other
182	Denise	Johns	1964-09-03	0991 803 6281	0800 104 4846	aliquet.sem@arcuSedeu.co.uk	Female	White British
183	Morgan	Donovan	2002-11-21	0500 696928	(0112) 512 2622	libero.Integer.in@rutrumlorem.org	Female	Black other
184	Stacey	Aguirre	1998-06-16	0886 649 6244	(016977) 5995	vitae.aliquam.eros@ligula.net	Female	White British
185	Camille	Rowe	1960-05-16	0800 1111	0800 027 6929	augue.malesuada@congueIn.com	Female	Chinese
186	Iliana	Conway	1992-01-15	055 3353 1890	(01635) 866302	in@sollicitudinorcisem.ca	Female	Black African
187	Alisa	Farmer	1969-07-20	0800 1111	070 4031 1574	et.tristique.pellentesque@etipsum.com	Female	Chinese
188	Ingrid	Hood	1987-01-20	(0161) 369 3059	0500 777118	ipsum.porta@Lorem.ca	Female	White British
189	Cassady	Foley	1962-11-07	055 8903 1825	(016977) 2388	semper.dui.lectus@vitae.org	Female	Chinese
190	Elaine	Anderson	1981-03-01	0933 495 8777	07642 907684	vel@in.com	Female	Black other
191	McKenzie	Gould	2005-11-19	0800 167 9642	076 3592 0536	sit.amet@luctusaliquet.com	Female	Black African
192	Hedwig	Vance	1974-09-01	055 2163 7878	076 9295 6980	Maecenas.ornare.egestas@eros.com	Female	White British
193	Vanna	Walsh	1980-12-05	0500 127862	070 7690 5465	montes.nascetur.ridiculus@laoreetipsumCurabitur.net	Female	White other
194	Hayley	Cleveland	1967-05-01	0892 584 5543	056 8979 7986	a.dui.Cras@temporaugueac.edu	Female	Black Caribbean
195	Tamara	Wiley	1958-02-27	055 0430 6789	(020) 7746 9944	Donec.est@Aliquam.org	Female	Other
196	Summer	Wood	2001-02-21	0800 408 5381	(016977) 2842	nonummy@nectempusmauris.com	Female	White British
197	Octavia	Nixon	1956-08-14	070 2022 6886	(01425) 74613	eu.dolor.egestas@et.ca	Female	White other
198	Pamela	Gordon	1969-09-22	0800 312 8674	0800 1111	habitant.morbi.tristique@tacitisociosquad.ca	Female	Black Caribbean
199	Aiko	House	1958-12-23	07624 732155	07578 010981	nulla@tellusPhaselluselit.edu	Female	Black Caribbean
200	Amena	Dickerson	1962-10-28	(0115) 093 4000	(016977) 5752	non.magna.Nam@consequatenim.ca	Female	White British
201	John	Smith	\N	\N	\N	\N	\N	\N
202	Aicha	Whittaker	\N	\N	\N	\N	\N	\N
204	Baker	Harrison	\N	\N	\N	\N	\N	\N
205	Billy	Reynolds	\N	\N	\N	\N	\N	\N
207	Rachel	Starling	2014-08-06	2349243908	\N	\N	Female	White British
\.


--
-- Data for Name: person_group_relation; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY person_group_relation (id, person, "group") FROM stdin;
1	42	1
2	201	1
3	2	37
4	1	37
5	6	37
6	2	2
7	4	9
8	2	9
9	2	1
10	3	1
12	4	2
13	4	1
14	5	2
15	7	2
16	202	2
17	3	12
18	4	12
19	6	12
21	8	12
23	21	12
24	15	12
26	2	12
28	1	1
29	204	2
31	6	2
33	3	2
37	1	2
38	9	1
39	5	1
40	205	1
49	2	103
50	4	103
51	6	103
52	8	103
53	9	103
\.


--
-- Name: person_group_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('person_group_relation_id_seq', 53, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('person_id_seq', 207, true);


--
-- Data for Name: person_qual_relation; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY person_qual_relation (id, person, qual) FROM stdin;
\.


--
-- Name: person_qual_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('person_qual_relation_id_seq', 2, true);


--
-- Data for Name: qual; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY qual (id, name, details) FROM stdin;
1	Angling Level 2 Award	Teaches the basics of fly-fishing on Saltwell Park lake.
\.


--
-- Data for Name: qual_group_relation; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY qual_group_relation (id, qual, "group") FROM stdin;
1	1	68
2	1	103
\.


--
-- Name: qual_group_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('qual_group_relation_id_seq', 2, true);


--
-- Name: qual_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('qual_id_seq', 1, true);


--
-- Data for Name: register; Type: TABLE DATA; Schema: public; Owner: EdbertsApp
--

COPY register (id, date, "group", people_present, people_not_present) FROM stdin;
3	2014-11-25	1	[2,3,4,42,201]	[]
4	2014-11-25	2	[2,5,202]	[1,4,7]
9	2014-11-26	1	[4,205]	[1,2,3,9,42,201,5]
10	2014-11-26	2	[1,2,3,4,5,6,7,202,204]	[]
\.


--
-- Name: register_id_seq; Type: SEQUENCE SET; Schema: public; Owner: EdbertsApp
--

SELECT pg_catalog.setval('register_id_seq', 10, true);


--
-- Name: p_group_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY p_group
    ADD CONSTRAINT p_group_pkey PRIMARY KEY (id);


--
-- Name: person_group_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY person_group_relation
    ADD CONSTRAINT person_group_relation_pkey PRIMARY KEY (id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person_qual_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY person_qual_relation
    ADD CONSTRAINT person_qual_relation_pkey PRIMARY KEY (id);


--
-- Name: qual_group_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY qual_group_relation
    ADD CONSTRAINT qual_group_relation_pkey PRIMARY KEY (id);


--
-- Name: qual_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY qual
    ADD CONSTRAINT qual_pkey PRIMARY KEY (id);


--
-- Name: register_pkey; Type: CONSTRAINT; Schema: public; Owner: EdbertsApp; Tablespace: 
--

ALTER TABLE ONLY register
    ADD CONSTRAINT register_pkey PRIMARY KEY (id);


--
-- Name: person_group_relation_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_group_relation
    ADD CONSTRAINT person_group_relation_group_fkey FOREIGN KEY ("group") REFERENCES p_group(id);


--
-- Name: person_group_relation_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_group_relation
    ADD CONSTRAINT person_group_relation_person_fkey FOREIGN KEY (person) REFERENCES person(id);


--
-- Name: person_qual_relation_person_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_qual_relation
    ADD CONSTRAINT person_qual_relation_person_fkey FOREIGN KEY (person) REFERENCES person(id);


--
-- Name: person_qual_relation_qual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY person_qual_relation
    ADD CONSTRAINT person_qual_relation_qual_fkey FOREIGN KEY (qual) REFERENCES qual(id);


--
-- Name: qual_group_relation_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY qual_group_relation
    ADD CONSTRAINT qual_group_relation_group_fkey FOREIGN KEY ("group") REFERENCES p_group(id);


--
-- Name: qual_group_relation_qual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY qual_group_relation
    ADD CONSTRAINT qual_group_relation_qual_fkey FOREIGN KEY (qual) REFERENCES qual(id);


--
-- Name: register_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: EdbertsApp
--

ALTER TABLE ONLY register
    ADD CONSTRAINT register_group_fkey FOREIGN KEY ("group") REFERENCES p_group(id);


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

