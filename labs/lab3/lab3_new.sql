set search_path to public, siatkowka;
--====================THEORY====================
--praca z datą i czasem
--current_date -> teraznieszą date
--current_time -> czas
--now() -> data + czas

--date_part('year/month/day/hours/week/doy/dow...', termin) - wyciąga cześc daty/czasu
-- (doy - day of year, dow-day of week)
--dla SQL extract(jednostka from termin)

-- data + INTERVAL 'ilość jednostka' -> dodawanie/odejmowanie czasu
-- jednostki: 'years', 'months', 'days', 'hours', 'minutes'
-- Przykład: current_date - INTERVAL '1 year 2 months' (data sprzed roku i 2 miesięcy)
-- Przykład: now() + INTERVAL '1 hour' (za godzinę)

-- FORMATOWANIE I KONWERSJA
-- to_char(data, 'wzorzec') -> zamienia datę na tekst w dowolnym formacie
-- Wzorce: 'YYYY' (rok), 'MM' (miesiąc), 'DD' (dzień), 'Day' (nazwa dnia), 'Month' (nazwa miesiąca)
-- Przykład: to_char(now(), 'DD-MM-YYYY HH24:MI')

-- OBLICZANIE RÓŻNICY (WIEKU)
-- age(data_koncowa, data_poczatkowa) -> zwraca dokładny interwał (ile lat, mies, dni minęło)
-- age(data_urodzenia) -> skrót, liczy wiek od "dzisiaj"
-- Przykład: age('2025-01-01', '2020-01-01') -> zwróci '5 years'

-- ZAOKRĄGLANIE DATY (DATE_TRUNC)
-- date_trunc('jednostka', data) -> "obcina" datę do początku podanej jednostki (zeruje mniejsze części)
-- Przykład: date_trunc('month', now()) -> zwraca pierwszy dzień bieżącego miesiąca o 00:00
-- Przykład: date_trunc('year', now()) -> zwraca 1 stycznia bieżącego rok

-- TWORZENIE DATY Z LICZB
-- make_date(rok, miesiąc, dzień) -> tworzy datę z trzech liczb
-- Przykład: make_date(2025, 12, 06)

--1 Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień
-- (idZamowienia, dataRealizacji), które mają być zrealizowane:

--1.1 między 12 i 20 listopada bieżącego roku,
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date) and
      date_part('month', datarealizacji) = 11 and
      date_part('day', datarealizacji) between 12 and 20;

--1.2 między 1 i 6 grudnia lub między 15 i 20 grudnia bieżącego roku
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date) and
    date_part('month', datarealizacji) = 12 and
    ((date_part('day', datarealizacji) between 1 and 6)
         or (date_part('day', datarealizacji) between 15 and 20));

--1.3 w grudniu bieżącego roku (nie używaj funkcji date_part ani extract),
select idzamowienia, datarealizacji
from zamowienia
where date_trunc('month', datarealizacji) = (date_trunc('year', current_date) + interval '11 month');
--               YYYY-MM-01               =               YYYY-01-01 + 11 months

--1.4 w listopadzie bieżącego roku (w tym i kolejnych zapytaniach użyj funkcji date_part),
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date) and
    date_part('month', datarealizacji) = 11;

--1.5 w listopadzie lub grudniu bieżącego roku,
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date) and
    date_part('month', datarealizacji) in (11, 12);

--1.6 17, 18 lub 19 dnia miesiąca
select idzamowienia, datarealizacji
from zamowienia
where date_part('day', datarealizacji) in (17, 18, 19);

--1.7 46 lub 47 tygodniu roku.
select idzamowienia, datarealizacji
from zamowienia
where date_part('week', datarealizacji) in (46, 47);