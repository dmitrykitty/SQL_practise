select nazwa, opis
from czekoladki;

select nazwa, cena, stan
from pudelka;

select *
from klienci;

SET SEARCH_PATH TO siatkowka;

select imie, nazwisko
from siatkarki;

set search_path to public;

select imie, nazwisko
from siatkarki;

set search_path to public, siatkowka;