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

--------------------------------------------------------------------

--REGEX(similar to 'pattern') % oraz _ tak samo jak dla like/ilike
--[AB]ma -> Ama lub Bma
--[a-z]ma -> myślnik oznacza zakres. Pasuje do "ama", "bma" ... aż do "zma".
--[^(0-9)]% -> dowolny ciag nie od liczb
--ko?t -> kt lub kot (0 lub 1)
--ko*t -> kt, kot, koot, ko...ot (0 lub wiecej)
--ko+t -> kot, ko...ot (1 lub wiecej)
--a{n} -> a powtorzone n razy
--a{n,} -> a powtorzone n lub wiecej razy
--a{n,m} -> a powtorzone od n do m razy

--------------------------------------------------------------------
--union, intersect, except wymaga jednakowej ilosci kolumn w podzapytaniach
--jezeli zakresy sie nie przecianja - lepiej uzywac union all zamiast union bo nie sprawdza dublikatow

--===========================================================

--1 Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień
-- (idZamowienia, dataRealizacji), które mają być zrealizowane:

--1.1 między 12 i 20 listopada bieżącego roku,
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date)
  and date_part('month', datarealizacji) = 11
  and date_part('day', datarealizacji) between 12 and 20;

--1.2 między 1 i 6 grudnia lub między 15 i 20 grudnia bieżącego roku
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date)
  and date_part('month', datarealizacji) = 12
  and ((date_part('day', datarealizacji) between 1 and 6)
    or (date_part('day', datarealizacji) between 15 and 20));

--1.3 w grudniu bieżącego roku (nie używaj funkcji date_part ani extract),
select idzamowienia, datarealizacji
from zamowienia
where date_trunc('month', datarealizacji) = (date_trunc('year', current_date) + interval '11 month');
--               YYYY-MM-01               =               YYYY-01-01 + 11 months

--1.4 w listopadzie bieżącego roku (w tym i kolejnych zapytaniach użyj funkcji date_part),
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date)
  and date_part('month', datarealizacji) = 11;

--1.5 w listopadzie lub grudniu bieżącego roku,
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', datarealizacji) = date_part('year', current_date)
  and date_part('month', datarealizacji) in (11, 12);

--1.6 17, 18 lub 19 dnia miesiąca
select idzamowienia, datarealizacji
from zamowienia
where date_part('day', datarealizacji) in (17, 18, 19);

--1.7 46 lub 47 tygodniu roku.
select idzamowienia, datarealizacji
from zamowienia
where date_part('week', datarealizacji) in (46, 47);

--================================================================

--2 Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
-- (idCzekoladki, nazwa, czekolada, orzechy, nadzienie), których nazwa:

--2.1 rozpoczyna się na literę 'S',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S%';

--2.2 rozpoczyna się na literę 'S' i kończy się na literę 'i',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S%i';

--2.3 rozpoczyna się na literę 'S' i zawiera słowo rozpoczynające się na literę 'm',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S% m%';

--2.4 rozpoczyna się na literę 'A', 'B' lub 'C',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '[SAC]%';

--2.5 zawiera rdzeń 'orzech' (może on wystąpić na początku i wówczas będzie pisany z wielkiej litery),
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa ilike '%orzech%';

select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '%[Oo]rzech%';

--2.6 rozpoczyna się na literę 'S' i zawiera w środku literę 'm',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa like 'S%m_%';

select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to 'S%m_%';

--2.7 zawiera słowo 'maliny' lub 'truskawki',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa ilike '%maliny%'
   or nazwa ilike '%truskawki%';

select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '%([Mm]aliny|[Tt]ruskawki)%';

--2.8 nie rozpoczyna się żadną z liter: 'D'-'K', 'S' i 'T',
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '[^D-KST]%';

--2.9 rozpoczyna się od 'Slod' ('Słod'),
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '(Slod|Słod)%';

--2.10 składa się dokładnie z jednego słowa
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa not like '% %';

select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nazwa similar to '[a-zA-Z]+';

--================================================================

--3 Napisz zapytanie w języku SQL oparte na tabeli Klienci, które:

--3.1 wyświetla unikalne nazwy miast, z których pochodzą klienci cukierni
-- i które składają się z więcej niż jednego słowa,
select distinct miejscowosc
from klienci
where miejscowosc ilike '% %';

--jezeli akceptujemy miasta z myslnikiem
select distinct miejscowosc
from klienci
where miejscowosc similar to '%[ -]%';

--3.2 wyświetla nazwy i numery telefonów klientów,
-- którzy podali numer stacjonarny telefonu (np. 012 222 22 00),
select nazwa, telefon
from klienci
where telefon similar to '[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}';

--3.3 wyświetla nazwy i numery telefonów klientów, którzy podali numer komórkowy telefonu,
select nazwa, telefon
from klienci
where telefon not similar to '[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}';

--no lub założmy, że nie mamy polecenia dla telefonu stacjonarnego
select nazwa, telefon
from klienci
where telefon similar to '[0-9]{3} [0-9]{3} [0-9]{3}';

--================================================================

--4 Korzystając z zapytań z zadania 2.4 oraz operatorów UNION, INTERSECT, EXCEPT napisz zapytanie w języku SQL
-- wyświetlające informacje na temat czekoladek (idCzekoladki, nazwa, masa, koszt), których:

--4.1 masa mieści się w przedziale od 15 do 24 g lub koszt produkcji mieści się w przedziale od 15 do 24 gr,
--btw tutaj łatwiej połączyć zwykłym OR
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 15 and 24
union
select idczekoladki, nazwa, masa, koszt
from czekoladki
where koszt between 0.15 and 0.24;

--4.2 masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji nie mieści się w przedziale od 25 do 35 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35
except
select idczekoladki, nazwa, masa, koszt
from czekoladki
where koszt between 0.25 and 0.35;

--4.3 [masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr]
-- lub [masa mieści się w przedziale od 25 do 35 g i koszt produkcji mieści się w przedziale od 25 do 35 gr],
--tip: jezeli zakresy sie nie przecinaja - lepiej uzyc union all (bedzie szybciej, bo nie będzie sprawdzał dublikatow)
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 15 and 24
  and koszt between 0.15 and 0.24
union all
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35
  and koszt between 0.25 and 0.35;

--4.4 masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 15 and 24
intersect
select idczekoladki, nazwa, masa, koszt
from czekoladki
where koszt between 0.15 and 0.24;

--4.5 masa mieści się w przedziale od 25 do 35 g,
-- ale koszt produkcji nie mieści się ani w przedziale od 15 do 24 gr, ani w przedziale od 29 do 35 gr.
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35
except
(select idczekoladki, nazwa, masa, koszt
 from czekoladki
 where koszt between 0.15 and 0.24
 union all
 select idczekoladki, nazwa, masa, koszt
 from czekoladki
 where koszt between 0.29 and 0.35
);

--czy warto stosowac tutaj działań na zbiorach? nie, tylko w ramach zadania...
SELECT idczekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa BETWEEN 25 AND 35
  AND koszt NOT BETWEEN 0.15 AND 0.24
  AND koszt NOT BETWEEN 0.29 AND 0.35;

--================================================================