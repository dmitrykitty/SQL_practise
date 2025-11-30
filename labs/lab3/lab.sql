--Work with date and time

select date '2025-09-28' + integer '7';
-- date ’2025 -10 -05 ’
select date '2025-09-28' + time '03:00';
-- timestamp ’2025 -09 -28 03:00:00 ’
select interval '1 day' + interval '1 hour';
-- interval ’1 day 01:00:00 ’
select timestamp '2025-09-28 01:00' + interval '23 hours';
-- timestamp ’2025 -09 -29 00:00:00 ’
select time '01:00' + interval '3 hours';
-- time ’04:00:00 ’
select date '2025-10-01' - date '2025-09-28';
-- integer ’3’ (days)
select date '2025-09-28' - interval '1 hour';
-- timestamp ’2025 -09 -27 23:00:00 ’
select time '05:00' - time '03:00';
-- interval ’02:00:00 ’
select 900 * interval '1 second';
-- interval ’00:15:00 ’

-- date ’2025 -10 -25’
-- time ’09:30:00’
-- timestamp ’2025 -10 -25 10:29:01.45’

select now();
select age(timestamp '1997-01-17'); -- -> now() - X
select age(current_date::timestamp);
select age(now(), current_date::timestamp);

select current_date;

--ZADANIE 1
--Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień
-- (idZamowienia, dataRealizacji), które mają być zrealizowane:

--1.1 między 12 i 20 listopada bieżącego roku,
select idzamowienia, datarealizacji
from zamowienia
where date_part('year', current_date) = date_part('year', datarealizacji)
  and date_part('month', datarealizacji) = 11
  and date_part('day', datarealizacji) between 12 and 20;


SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE
  -- 1. Sprawdź, czy rok się zgadza z bieżącym rokiem
    EXTRACT(YEAR FROM datarealizacji) = EXTRACT(YEAR FROM current_date)
  -- 2. Sprawdź, czy to Listopad
  AND EXTRACT(MONTH FROM datarealizacji) = 11
  -- 3. Sprawdź, czy dzień jest w zakresie
  AND EXTRACT(DAY FROM datarealizacji) BETWEEN 12 AND 20;

SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji BETWEEN
          -- Buduj datę 'YYYY-11-12' gdzie YYYY to bieżący rok
          make_date(EXTRACT(YEAR FROM current_date)::int, 11, 12)
          AND
          -- Buduj datę 'YYYY-11-20'
          make_date(EXTRACT(YEAR FROM current_date)::int, 11, 20);


--1.3 w grudniu bieżącego roku (nie używaj funkcji date_part ani extract),


SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE
    -- 1. Obetnij datę realizacji do pierwszego dnia miesiąca
    date_trunc('month', datarealizacji)
        = -- 2. Porównaj ją z pierwszym dniem grudnia bieżącego roku
    (date_trunc('year', current_date) + INTERVAL '11 months');


SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa LIKE 'S%';



SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa LIKE 'S%i';



SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa LIKE 'S% m%';


SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa LIKE 'A%'
   OR nazwa LIKE 'B%'
   OR nazwa LIKE 'C%';



SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ILIKE '%orzech%';


SELECT DISTINCT miejscowosc
FROM klienci
WHERE miejscowosc LIKE '% %';

select nazwa, miasto
from druzyny
where miasto like '_% %_';



SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ __ __';

--similar to

-- Sprawdź, czy tekst zaczyna się na 'Pan'
SELECT 'Pan Tadeusz' SIMILAR TO 'Pan%';
-- Zwraca: true

-- Sprawdź, czy wzorzec to 'K_t' (Kot, Kat, K_t itp.)
SELECT 'Kot' SIMILAR TO 'K_t'; -- Zwraca: true
SELECT 'Kat' SIMILAR TO 'K_t'; -- Zwraca: true
SELECT 'Kt' SIMILAR TO 'K_t';
-- Zwraca: false

-- Sprawdź, czy imię to 'Kasia' LUB 'Basia'
SELECT 'Kasia' SIMILAR TO '(K|B)asia'; -- Zwraca: true
SELECT 'Basia' SIMILAR TO '(K|B)asia'; -- Zwraca: true
SELECT 'Jasia' SIMILAR TO '(K|B)asia';
-- Zwraca: false

-- Sprawdź kod pocztowy zaczynający się na 30- LUB 31-
SELECT '30-120' SIMILAR TO '3(0|1)-%';
-- Zwraca: true

-- Sprawdź, czy litera to 'a' LUB 'o'
SELECT 'Bok' SIMILAR TO 'B[ao]k'; -- Zwraca: true
SELECT 'Bak' SIMILAR TO 'B[ao]k'; -- Zwraca: true
SELECT 'Buk' SIMILAR TO 'B[ao]k';
-- Zwraca: false

-- Działa też z zakresami
SELECT 'plik_7' SIMILAR TO 'plik_[0-9]'; -- Zwraca: true
SELECT 'plik_A' SIMILAR TO 'plik_[A-Z]';
-- Zwraca: true

-- Sprawdź, czy litera nie jest 'a' ani 'o'
SELECT 'Buk' SIMILAR TO 'B[^ao]k'; -- Zwraca: true
SELECT 'Bok' SIMILAR TO 'B[^ao]k';
-- Zwraca: false

-- Dopasuj 'Tshirt', 'T-shirt', 'T--shirt' itd.
SELECT 'Tshirt' SIMILAR TO 'T(-*)shirt'; -- Zwraca: true
SELECT 'T-shirt' SIMILAR TO 'T(-*)shirt'; -- Zwraca: true
SELECT 'T---shirt' SIMILAR TO 'T(-*)shirt';
-- Zwraca: true

-- Dopasuj 'T-shirt', 'T--shirt', ale NIE 'Tshirt'
SELECT 'T-shirt' SIMILAR TO 'T(-+)shirt'; -- Zwraca: true
SELECT 'T---shirt' SIMILAR TO 'T(-+)shirt'; -- Zwraca: true
SELECT 'Tshirt' SIMILAR TO 'T(-+)shirt'; -- Zwraca: false

SELECT 'A123' SIMILAR TO 'A[0-9]{3}'; -- Zwraca: true
SELECT 'A12' SIMILAR TO 'A[0-9]{3}';
-- Zwraca: false

-- Hasło musi mieć co najmniej 8 znaków (używamy '%', bo _ nie jest tu RegEx)
SELECT 'abcdefgh' SIMILAR TO '_{8,}%'; -- Zwraca: true
SELECT 'abc' SIMILAR TO '_{8,}%'; -- Zwraca: false

SELECT '12345' SIMILAR TO '[0-9]{5,6}'; -- Zwraca: true
SELECT '123456' SIMILAR TO '[0-9]{5,6}'; -- Zwraca: true
SELECT '1234' SIMILAR TO '[0-9]{5,6}';
-- Zwraca: false

-- Sprawdź, czy kod ma 3 wielkie litery
SELECT 'ABC' SIMILAR TO '[[:upper:]]{3}';
-- Zwraca: true

-- Sprawdź, czy tekst to litery, a potem cyfry
SELECT 'Noc10' SIMILAR TO '[[:alpha:]]+[[:digit:]]+';
-- Zwraca: true

-- Sprawdź, czy tekst zawiera znak interpunkcyjny
SELECT 'Stop!' SIMILAR TO '%[[:punct:]]%';
-- Zwraca: true


-----ZADANIE 4--------
SELECT idczekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa BETWEEN 15 AND 24
UNION
SELECT idczekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24;


SELECT idczekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE masa BETWEEN 25 AND 35
EXCEPT
SELECT idczekoladki, nazwa, masa, koszt
FROM czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35;

(SELECT idczekoladki, nazwa, masa, koszt
 FROM czekoladki
 WHERE masa BETWEEN 15 AND 24
 INTERSECT
 SELECT idczekoladki, nazwa, masa, koszt
 FROM czekoladki
 WHERE koszt BETWEEN 0.15 AND 0.24)

UNION

(SELECT idCzekoladki, nazwa, masa, koszt
 FROM czekoladki
 WHERE masa BETWEEN 25 AND 35
 INTERSECT
 SELECT idCzekoladki, nazwa, masa, koszt
 FROM czekoladki
 WHERE koszt BETWEEN 25 AND 35);


-----ZADANIE 5--------
--Korzystając z operatorów UNION, INTERSECT, EXCEPT napisz zapytanie w języku SQL wyświetlające:

--5.1 identyfikatory klientów, którzy nigdy nie złożyli żadnego zamówienia,
SELECT idklienta
FROM klienci
EXCEPT
SELECT DISTINCT idklienta
FROM zamowienia;

--5.2 identyfikatory klientów, którzy nigdy nie złożyli żadnego zamówienia,
SELECT idpudelka
FROM pudelka
EXCEPT
SELECT DISTINCT idpudelka
FROM artykuly

--5.3 nazwy klientów, czekoladek i pudełek, które zawierają rz (lub Rz)
SELECT nazwa
FROM klienci
WHERE nazwa ILIKE '%rz%'
UNION
SELECT nazwa
FROM czekoladki
WHERE nazwa ILIKE '%rz%'
UNION
SELECT nazwa
FROM pudelka
WHERE nazwa ILIKE '%rz%';





