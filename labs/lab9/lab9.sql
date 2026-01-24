set search_path to public, siatkowka;
--====================THEORY====================

-- enum create type pora_roku as enum (’wiosna’,’lato’,’jesien’,’zima’);
-- create table pupupu (
--   pora pora_roku); i bédzie błąd jak wartosc pory będzie not in (’wiosna’,’lato’,’jesien’,’zima’);

-- domain tez pozwala tworzyc ograniczenia tylka zadane za pomoca in, like, similar to, ~
-- create domain kod_pocztowy as varchar(6)
-- default 30-001
-- check(value similar to '[0-9]{2}-[0-9]{3}');

-- constrains (not null, unique, PK, default, check(warunek), references


create schema test1;
set search_path to test1;

create table kompozycje
(
    idkompozycji varchar(4) primary key,
    nazwa        varchar(20) unique not null,           --not null nie moze miec przypisanej nazwy
    cena         numeric(7, 2)
        constraint min_cena check (cena >= 40.00),
    opis         varchar(80) unique nulls not distinct, --mozna dodac zeby nulli były rowne pomiedzy sobą
    stan         integer default 2
);


create table pracownicy
(
    iddzialu char(4),
    numer    integer,
    pensja   numeric(7, 2),
    premia   numeric(7, 2),
    primary key (iddzialu, numer), --zlozone PK zadaj sie tylko dla calej tabeli a nie na poziomie kolumn
    constraint premia_pensja check (premia <= pensja)
);

--dodanie kolumny do tablicy
alter table pracownicy
    add column plec char(1)
        constraint plec_constraint check (plec in ('M', 'K'));

--usunięcie kolumny
alter table pracownicy
    drop column numer;

--zmiana nazwy kolumny
alter table pracownicy
    rename column plec to plec_pracownika;

--zmiana nazwy tabeli
alter table pracownicy
    rename to pracowniki;

--dodawanie constraintow
--na poziomie tabeli
alter table pracowniki
    add constraint penska_check check ( pensja > 1000.00 );

alter table pracowniki
    add constraint unique_id unique (iddzialu);

--na poziomie columny
alter table pracowniki
    alter column iddzialu set not null;

--dodawanie FK
alter table pracowniki
    add foreign key (plec_pracownika) references kompozycje (nazwa);

--usuwanie constraintow
--na poziomie tabeli
alter table pracowniki
    drop constraint unique_id;
--po to trzeba nadawac nazwy do constraintow

--na poziomie columny
alter table pracowniki
    alter column iddzialu drop not null;


--================================================
-- ZADANIE 1
-- Przygotuj skrypt implementujący bazę danych kwiaciarnia zgodnie z przedstawionym poniżej projektem i opisem.
--
-- Uwaga: Baza danych kwiaciarnia ma zostać umieszczona w schemacie kwiaciarnia (patrz zadanie 1.1).

create schema kwiaciarnia;
set search_path to kwiaciarnia;

create table klienci
(
    idklienta varchar(10) primary key,
    haslo     varchar(10) not null
        constraint check_length check (length(haslo) between 4 and 10),
    nazwa     varchar(40) not null,
    miasto    varchar(40) not null,
    kod       char(6)     not null
        constraint check_code check (kod similar to '[0-9]{2}-[0-9]{3}'),
    adres     varchar(40) not null,
    email     varchar(40)
        constraint check_password check ( email like '%@%'),
    telefon   varchar(16) not null,
    fax       varchar(16),
    nip       char(13)
        constraint check_nip check (nip similar to '[0-9]{13}'),
    regon     char(9)
        constraint check_regon check ( regon similar to '[0-9]{9}')
);

alter table klienci
    drop constraint check_code;

alter table klienci
    drop constraint check_nip;

alter table klienci
    drop constraint check_regon;

alter table klienci
    add constraint check_nip check (nip similar to '[0-9]{3}-[0-9]{3}-[0-9]{2}-[0-9]{2}');

CREATE TABLE kompozycje
(
    idkompozycji char(5) PRIMARY KEY,
    nazwa        varchar(40)    NOT NULL,
    opis         varchar(100),
    cena         numeric(12, 2) NOT NULL
        constraint check_cena_min CHECK (cena >= 40.00),
    minimum      int,
    stan         int
);

CREATE TABLE odbiorcy
(
    idodbiorcy serial PRIMARY KEY,
    nazwa      varchar(40) NOT NULL,
    miasto     varchar(40) NOT NULL,
    kod        char(6)     NOT NULL
        CONSTRAINT check_kod_odbiorcy CHECK (kod SIMILAR TO '[0-9]{2}-[0-9]{3}'),
    adres      varchar(40) NOT NULL
);

create table zamowienia
(
    idzamowienia int primary key,
    idklienta    varchar(10) not null references klienci (idklienta),
    idobiorcy    int         not null references odbiorcy (idodbiorcy),
    idkompozycji char(5)     not null references kompozycje (idkompozycji),
    termin       date        not null,
    cena         numeric(12, 2),
    zaplacone    boolean,
    uwagi        varchar(200)
);

create table historia
(
    idzamowienia int primary key,
    idklienta    varchar(10),
    idkompozycji char(5),
    cena         numeric(12, 2),
    termin       date
);

create table zapotrzebowanie
(
    idkompozycji char(5) primary key references kompozycje (idkompozycji),
    data         date
);


--================================================
--ZADANIE 2
-- Wykonaj skrypt tworzący relacje w bazie danych kwiaciarnia.
-- Przygotuj odpowiednio dane z pliku kwiaciarnia2dane-tekst.txt i zaimportuj je do bazy danych.
-- Sprawdź (np. wykonując zapytania), czy wszystkie dane zostały zaimportowane do bazy danych.
-- Jak sprawdzić wartość klucza głównego dla ostatnio dodanego rekordu do tabeli odbiorcy w ramach tej samej sesji?

copy kwiaciarnia.klienci from stdin with (delimiter ';', null 'BRAK DANYCH');
\
--dane
\.

copy kwiaciarnia.kompozycje from stdin with (delimiter ';', null 'BRAK DANYCH');
\
dane
\.

copy kwiaciarnia.odbiorcy (nazwa, miasto, kod, adres) from stdin with (delimiter ';', null 'BRAK DANYCH');
\
dane
\.


copy kwiaciarnia.zamowienia from stdin with (delimiter ';', null 'BRAK DANYCH');
\
dane
\.

copy kwiaciarnia.historia from stdin with (delimiter ';', null 'BRAK DANYCH');
\
dane
\.


--================================================
--ZADANIE 3
-- Przygotuj skrypt implementujący bazę danych firma zgodnie z przedstawionym poniżej opisem.
-- Uwaga: Baza danych ma zostać umieszczona w schemacie firma.
-- Ponieważ występują cykliczne zależności między relacjami dzialy i pracownicy,
-- klucz obcy w relacji dzialy należy dodać za pomocą polecenia alter table po utworzeniu obu relacji:

create schema firma;
set search_path to firma;

create table dzialy
(
    iddzialu    char(5) primary key,
    nazwa       varchar(32) not null,
    lokalizacja varchar(24) not null,
    kierownik   int
);

create table pracownicy
(
    idpracownika  int primary key,
    nazwisko      varchar(32) not null,
    imie          varchar(16) not null,
    dataUrodzenia date        not null,
    dzial         char(5) references dzialy (iddzialu),
    stanowisko    varchar(24),
    przelozony    int references pracownicy (idpracownika),
    pobory        numeric(8, 2)
);

create sequence premia_seq start with 100 increment by 10;

create table premie
(
    idpremii     int primary key default nextval('premia_seq'),
    idpracownika int  not null references pracownicy (idpracownika),
    dataWyplaty  date not null,
    kwota        numeric(8, 2)
        constraint min_kwota check (kwota >= 1000)
);

alter sequence premia_seq owned by premie.idpremii; --bedzie usunieta wraz z tabelą premie w razie czego

alter table dzialy
    add foreign key (kierownik) references pracownicy (idpracownika) on update cascade deferrable;

--================================================
--ZADANIE 4
-- Wykonaj skrypt tworzący tabele w bazie danych firma.
-- Przygotuj skrypt z instrukcjami insert into, wstawiający do bazy firma poniższe krotki.
--     Dodatkowo przygotuj krotki do wstawienia do relacji premie (co najmniej 10), aby przetestować działanie sekwencji.
begin;

SET CONSTRAINTS ALL DEFERRED;

insert into dzialy(iddzialu, nazwa, lokalizacja, kierownik)
values ('PH101', 'Handlowy', 'Marki', 27),
       ('PR202', 'Projektowy', 'Olecko', 72),
       ('PK101', 'Personalny', 'Niwka', 73);


insert into firma.pracownicy
values (27, 'Kruk', 'Adam', '15/12/1989', 'PH101', 'kierownik', null, 9200.00),
       (72, 'Kowalik', 'Adam', '15/11/1989', 'PR202', 'kierownik', null, 8800.00),
       (73, 'Kowalus', 'Adam', '12/11/1998', 'PK101', 'kierownik', null, 8700.00),
       (29, 'Babik', 'Małgorzata', '11/11/1982', 'PH101', 'księgowa', 27, 6000.00),
       (30, 'Sowa', 'Marta', '10/12/1996', 'PH101', 'sekretarka', 27, 4500.00),
       (34, 'Niemczyk', 'Piotr', '07/03/1995', 'PH101', 'manager', 27, 6700.00),
       (35, 'Walczak', 'Piotr', '07/08/1998', 'PH101', 'manager', 27, 6700.00),
       (42, 'Sitarz', 'Paulina', '17/08/2002', 'PH101', 'handlowiec', 34, 5400.00),
       (44, 'Sitarz', 'Wojciech', '17/08/2002', 'PH101', 'handlowiec', 34, 5400.00),
       (45, 'Kowalczyk', 'Marek', '17/03/1999', 'PH101', 'handlowiec', 34, 5200.00),
       (47, 'Michno', 'Jacek', '10/01/2004', 'PH101', 'handlowiec', 35, 5600.00),
       (48, 'Kopera', 'Dorota', '27/05/2000', 'PH101', 'handlowiec', 35, 5600.00),
       (52, 'Krupa', 'Jacek', '11/06/1993', 'PH101', 'handlowiec', 35, 5200.00),
       (62, 'Witek', 'Piotr', '13/05/2001', 'PH101', 'handlowiec', 35, 5000.00),
       (64, 'Wilk', 'Piotr', '13/09/2006', 'PH101', 'stażysta', 47, 3000.00),
       (31, 'Srokiewicz', 'Maria', '10/10/2000', 'PR202', 'sekretarka', 72, 4500.00),
       (84, 'Lisek', 'Wanda', '07/04/1995', 'PR202', 'manager', 72, 6700.00),
       (85, 'Ława', 'Paweł', '07/12/1990', 'PR202', 'manager', 72, 6700.00),
       (86, 'Listwa', 'Adam', '02/12/1988', 'PR202', 'projektant', 84, 5500.00),
       (87, 'Tylutek', 'Adam', '02/03/1998', 'PR202', 'projektant', 84, 5500.00),
       (91, 'Wilk', 'Anna', '12/04/2004', 'PR202', 'stażysta', 86, 3000.00),
       (92, 'Lipecki', 'Łukasz', '10/04/2003', 'PR202', 'stażysta', 87, 3000.00),
       (12, 'Kowalik', 'Artur', '13/12/1988', 'PR202', 'analityk', 84, 5900.00),
       (17, 'Kowalik', 'Amadeusz', '17/12/1988', 'PR202', 'analityk', 85, 5900.00),
       (97, 'Pałac', 'Michalina', '20/01/1999', 'PK101', 'sekretarka', 73, 4500.00),
       (98, 'Lisiecka', 'Joanna', '23/01/1991', 'PK101', 'rekruterka', 73, 6100.00),
       (99, 'Dereń', 'Karolina', '13/08/1993', 'PK101', 'rekruterka', 73, 6100.00),
       (66, 'Englert', 'Anna', '19/07/2006', 'PK101', 'stażysta', 99, 3000.00);

commit;


INSERT INTO premie (idpracownika, dataWyplaty, kwota)
VALUES (27, '2026-01-20', 2500.00), -- Kierownik PH101
       (72, '2026-01-20', 2100.00), -- Kierownik PR202
       (73, '2026-01-20', 2000.00), -- Kierownik PK101
       (29, '2026-01-21', 1500.00), -- Księgowa
       (34, '2026-01-21', 1800.00), -- Manager
       (35, '2026-01-22', 1800.00), -- Manager
       (84, '2026-01-22', 1700.00), -- Manager
       (85, '2026-01-23', 1700.00), -- Manager
       (98, '2026-01-23', 1200.00), -- Rekruterka
       (99, '2026-01-24', 1200.00); -- Rekruterka


--ZADANIE 5 Do bazy danych dodaj:
-- 1 Widok udostępniający jednocześnie dane nadawcy, odbiorcy oraz identyfikator i nazwę kompozycji oraz uwagi do zamówienia.
create view zamowienie_info as
select o.idodbiorcy, o.nazwa nazwa_odbiorcy, z.idzamowienia, k.idkompozycji, k.nazwa nazwa_kompozycji
from kompozycje k
         join zamowienia z on k.idkompozycji = z.idkompozycji
         join odbiorcy o on o.idodbiorcy = z.idobiorcy
order by o.idodbiorcy;

select *
from zamowienie_info;
