CREATE SCHEMA kolokwium;


CREATE TABLE dania.dania(
    id_dania integer NOT NULL,
    nazwa character varying(255) NOT NULL,
    gramatura integer NOT NULL,
    kalorycznosc integer NOT NULL,
    kuchnia character varying(100) DEFAULT NULL::character varying,
    wymaga_podgrzania boolean NOT NULL,
    koszt_produkcji numeric(5,2) NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 117131)
-- Name: dania_iddania_seq; Type: SEQUENCE; Schema: kolokwium; Owner: -
--

CREATE SEQUENCE dania.dania_iddania_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 221
-- Name: dania_iddania_seq; Type: SEQUENCE OWNED BY; Schema: kolokwium; Owner: -
--

ALTER SEQUENCE dania.dania_iddania_seq OWNED BY dania.dania.id_dania;


--
-- TOC entry 216 (class 1259 OID 117084)
-- Name: diety; Type: TABLE; Schema: kolokwium; Owner: -
--

CREATE TABLE dania.diety(
    id_diety integer NOT NULL,
    nazwa character varying(150) NOT NULL,
    gluten boolean DEFAULT true NOT NULL,
    laktoza boolean DEFAULT true NOT NULL,
    wege boolean DEFAULT false NOT NULL,
    keto boolean DEFAULT false NOT NULL,
    opakowania_eko boolean DEFAULT false NOT NULL,
    cena_dzien numeric(5,2) NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 117082)
-- Name: diety_iddiety_seq; Type: SEQUENCE; Schema: kolokwium; Owner: -
--

CREATE SEQUENCE dania.diety_iddiety_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 215
-- Name: diety_iddiety_seq; Type: SEQUENCE OWNED BY; Schema: kolokwium; Owner: -
--

ALTER SEQUENCE dania.diety_iddiety_seq OWNED BY dania.diety.id_diety;


--
-- TOC entry 223 (class 1259 OID 117139)
-- Name: dostepnosc; Type: TABLE; Schema: kolokwium; Owner: -
--

CREATE TABLE dania.dostepnosc(
    id_diety integer NOT NULL,
    id_dania integer NOT NULL,
    data_dostawy date NOT NULL,
    pora_dnia character varying NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 117092)
-- Name: klienci; Type: TABLE; Schema: kolokwium; Owner: -
--

CREATE TABLE dania.klienci(
    id_klienta integer NOT NULL,
    nazwa character varying(130) NOT NULL,
    ulica character varying(30) NOT NULL,
    miejscowosc character varying(15) NOT NULL,
    kod character(6) NOT NULL,
    telefon character varying(20) NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 117090)
-- Name: klienci_idklienta_seq; Type: SEQUENCE; Schema: kolokwium; Owner: -
--

CREATE SEQUENCE dania.klienci_idklienta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 217
-- Name: klienci_idklienta_seq; Type: SEQUENCE OWNED BY; Schema: kolokwium; Owner: -
--

ALTER SEQUENCE dania.klienci_idklienta_seq OWNED BY dania.klienci.id_klienta;


--
-- TOC entry 224 (class 1259 OID 117157)
-- Name: wybory; Type: TABLE; Schema: kolokwium; Owner: -
--

CREATE TABLE dania.wybory(
    id_zamowienia integer NOT NULL,
    id_dania integer NOT NULL,
    data_dostawy date NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 117102)
-- Name: zamowienia; Type: TABLE; Schema: kolokwium; Owner: -
--

CREATE TABLE dania.zamowienia(
    id_zamowienia integer NOT NULL,
    id_klienta integer NOT NULL,
    id_diety integer NOT NULL,
    data_zlozenia date NOT NULL,
    dostawy_od date NOT NULL,
    dostawy_do date NOT NULL
);


--
-- TOC entry 219 (class 1259 OID 117100)
-- Name: zamowienia_idzamowienia_seq; Type: SEQUENCE; Schema: kolokwium; Owner: -
--

CREATE SEQUENCE dania.zamowienia_idzamowienia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 219
-- Name: zamowienia_idzamowienia_seq; Type: SEQUENCE OWNED BY; Schema: kolokwium; Owner: -
--

ALTER SEQUENCE dania.zamowienia_idzamowienia_seq OWNED BY dania.zamowienia.id_zamowienia;


--
-- TOC entry 3869 (class 2604 OID 117136)
-- Name: dania id_dania; Type: DEFAULT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.dania ALTER COLUMN id_dania SET DEFAULT nextval('dania.dania_iddania_seq'::regclass);


--
-- TOC entry 3861 (class 2604 OID 117087)
-- Name: diety id_diety; Type: DEFAULT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.diety ALTER COLUMN id_diety SET DEFAULT nextval('dania.diety_iddiety_seq'::regclass);


--
-- TOC entry 3867 (class 2604 OID 117095)
-- Name: klienci id_klienta; Type: DEFAULT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.klienci ALTER COLUMN id_klienta SET DEFAULT nextval('dania.klienci_idklienta_seq'::regclass);


--
-- TOC entry 3868 (class 2604 OID 117105)
-- Name: zamowienia id_zamowienia; Type: DEFAULT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.zamowienia ALTER COLUMN id_zamowienia SET DEFAULT nextval('dania.zamowienia_idzamowienia_seq'::regclass);


--
-- TOC entry 4026 (class 0 OID 117133)
-- Dependencies: 222
-- Data for Name: dania; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4020 (class 0 OID 117084)
-- Dependencies: 216
-- Data for Name: diety; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4027 (class 0 OID 117139)
-- Dependencies: 223
-- Data for Name: dostepnosc; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4022 (class 0 OID 117092)
-- Dependencies: 218
-- Data for Name: klienci; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4028 (class 0 OID 117157)
-- Dependencies: 224
-- Data for Name: wybory; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4024 (class 0 OID 117102)
-- Dependencies: 220
-- Data for Name: zamowienia; Type: TABLE DATA; Schema: kolokwium; Owner: -
--



--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 221
-- Name: dania_iddania_seq; Type: SEQUENCE SET; Schema: kolokwium; Owner: -
--

SELECT pg_catalog.setval('dania.dania_iddania_seq', 1, false);


--
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 215
-- Name: diety_iddiety_seq; Type: SEQUENCE SET; Schema: kolokwium; Owner: -
--

SELECT pg_catalog.setval('dania.diety_iddiety_seq', 1, false);


--
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 217
-- Name: klienci_idklienta_seq; Type: SEQUENCE SET; Schema: kolokwium; Owner: -
--

SELECT pg_catalog.setval('dania.klienci_idklienta_seq', 1, false);


--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 219
-- Name: zamowienia_idzamowienia_seq; Type: SEQUENCE SET; Schema: kolokwium; Owner: -
--

SELECT pg_catalog.setval('dania.zamowienia_idzamowienia_seq', 1, false);


--
-- TOC entry 3878 (class 2606 OID 117138)
-- Name: dania dania_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.dania
    ADD CONSTRAINT dania_pkey PRIMARY KEY (id_dania);


--
-- TOC entry 3872 (class 2606 OID 117089)
-- Name: diety diety_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.diety
    ADD CONSTRAINT diety_pkey PRIMARY KEY (id_diety);


--
-- TOC entry 3880 (class 2606 OID 117143)
-- Name: dostepnosc dostepnosc_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.dostepnosc
    ADD CONSTRAINT dostepnosc_pkey PRIMARY KEY (id_diety, id_dania, data_dostawy);


--
-- TOC entry 3874 (class 2606 OID 117097)
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (id_klienta);


--
-- TOC entry 3882 (class 2606 OID 117161)
-- Name: wybory wybory_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.wybory
    ADD CONSTRAINT wybory_pkey PRIMARY KEY (id_zamowienia, id_dania, data_dostawy);


--
-- TOC entry 3876 (class 2606 OID 117107)
-- Name: zamowienia zamowienia_pkey; Type: CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.zamowienia
    ADD CONSTRAINT zamowienia_pkey PRIMARY KEY (id_zamowienia);


--
-- TOC entry 3886 (class 2606 OID 117149)
-- Name: dostepnosc fk_dostepnosc_dania; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.dostepnosc
    ADD CONSTRAINT fk_dostepnosc_dania FOREIGN KEY (id_dania) REFERENCES dania.dania(id_dania);


--
-- TOC entry 3885 (class 2606 OID 117144)
-- Name: dostepnosc fk_dostepnosc_diety; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.dostepnosc
    ADD CONSTRAINT fk_dostepnosc_diety FOREIGN KEY (id_diety) REFERENCES dania.diety(id_diety);


--
-- TOC entry 3888 (class 2606 OID 117167)
-- Name: wybory fk_wybory_dania; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.wybory
    ADD CONSTRAINT fk_wybory_dania FOREIGN KEY (id_dania) REFERENCES dania.dania(id_dania);


--
-- TOC entry 3887 (class 2606 OID 117162)
-- Name: wybory fk_wybory_zamowienia; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.wybory
    ADD CONSTRAINT fk_wybory_zamowienia FOREIGN KEY (id_zamowienia) REFERENCES dania.zamowienia(id_zamowienia);


--
-- TOC entry 3884 (class 2606 OID 117113)
-- Name: zamowienia fk_zamowienia_diety; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.zamowienia
    ADD CONSTRAINT fk_zamowienia_diety FOREIGN KEY (id_diety) REFERENCES dania.diety(id_diety);


--
-- TOC entry 3883 (class 2606 OID 117108)
-- Name: zamowienia fk_zamowienia_klienci; Type: FK CONSTRAINT; Schema: kolokwium; Owner: -
--

ALTER TABLE ONLY dania.zamowienia
    ADD CONSTRAINT fk_zamowienia_klienci FOREIGN KEY (id_klienta) REFERENCES dania.klienci(id_klienta) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2022-11-19 17:54:42

--
-- PostgreSQL database dump complete
--

