SELECT k.nazwa
FROM klienci k;

SELECT k.nazwa, z.idzamowienia
FROM klienci k,
     zamowienia z; --bez sensu

SELECT k.nazwa, z.idzamowienia
FROM klienci AS k,
     zamowienia AS z
WHERE z.idklienta = k.idklienta;

SELECT k.nazwa, z.idzamowienia
FROM klienci k
         NATURAL JOIN zamowienia z; --laczy wedlug jednakowych nazw w roznych tabelach

SELECT k.nazwa, z.idzamowienia
FROM klienci k
         JOIN zamowienia z
              ON z.idklienta = k.idklienta;


SELECT k.nazwa, z.idzamowienia
FROM klienci k
         JOIN zamowienia z
              USING (idklienta);

-- ZADANIE 2--
--Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień (data realizacji, idzamowienia), które:

-- 2.1 zostały złożone przez klienta, który ma na imię Antoni,
SELECT z.datarealizacji, z.idzamowienia
FROM zamowienia z
WHERE z.idklienta IN (SELECT idklienta FROM klienci WHERE nazwa ILIKE '%Antoni');



SELECT k.nazwa, z.datarealizacji, z.idzamowienia
FROM zamowienia z
         JOIN klienci k ON z.idklienta = k.idklienta
WHERE k.nazwa ILIKE '%Antoni';


-- 2.2 zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica),
SELECT z.datarealizacji, z.idzamowienia, k.ulica
FROM zamowienia z
         JOIN klienci k ON z.idklienta = k.idklienta
WHERE k.ulica ILIKE '%/%';

-- 2.3 zostały złożone przez klienta z Krakowa do realizacji w listopadzie bieżącego roku.
SELECT z.datarealizacji, z.idzamowienia, k.ulica
FROM zamowienia z
         JOIN klienci k ON z.idklienta = k.idklienta
WHERE k.miejscowosc = 'Kraków'
  AND EXTRACT(YEAR FROM z.datarealizacji) = extract(YEAR FROM now())
  and EXTRACT(month FROM z.datarealizacji) = 11;


--ZADANIE 3--
--Napisz zapytanie w języku SQL wyświetlające informacje na temat klientów
-- (idklienta, nazwa, ulica, miejscowość), którzy:

--3.1 złożyli zamówienia z datą realizacji nie starszą niż sprzed piętnastu lat,
SELECT DISTINCT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji
FROM klienci k
         JOIN zamowienia z on k.idklienta = z.idklienta
where z.datarealizacji > (SELECT now() - INTERVAL '15 years');


--3.2 zamówili pudełko Kremowa fantazja lub Kolekcja jesienna,
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji --nie ok
FROM klienci k
         JOIN zamowienia z using (idklienta)
         join artykuly a using (idzamowienia)
         join pudelka p using (idpudelka)
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna')
GROUP BY k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji;


SELECT DISTINCT on (k.idklienta) k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji --niby ok
FROM klienci k
         JOIN zamowienia z using (idklienta)
         join artykuly a using (idzamowienia)
         join pudelka p using (idpudelka)
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna');

SELECT k.idklienta,
       k.nazwa,
       k.ulica,
       k.miejscowosc,
       -- Rozwiązanie: Mówisz bazie, którą datę wybrać z grupy
       MAX(z.datarealizacji) AS ostatnia_data_zamowienia
FROM klienci k
         JOIN zamowienia z using (idklienta)
         join artykuly a using (idzamowienia)
         join pudelka p using (idpudelka)
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna')
GROUP BY k.idklienta, k.nazwa, k.ulica, k.miejscowosc;


--3.3 złożyli przynajmniej jedno zamówienie,
SELECT DISTINCT ON (k.idklienta) k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji
FROM klienci k
         join public.zamowienia z on k.idklienta = z.idklienta;


--3.4 nie złożyli żadnych zamówień,
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc
FROM klienci k
         LEFT JOIN zamowienia z ON k.idklienta = z.idklienta
WHERE z.idzamowienia IS NULL;


--3.6 zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia,
SELECT DISTINCT k.idklienta, k.nazwa, k.ulica, k.miejscowosc
FROM klienci k
         JOIN zamowienia z using (idklienta)
         join artykuly a using (idzamowienia)
         join pudelka p using (idpudelka)
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna')
  AND a.sztuk >= 2;
--is it the same?
SELECT k.idklienta, k.nazwa, k.ulica, k.miejscowosc
FROM klienci k
         JOIN zamowienia z using (idklienta)
         join artykuly a using (idzamowienia)
         join pudelka p using (idpudelka)
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna')
  AND a.sztuk >= 2
GROUP BY k.idklienta, k.nazwa, k.ulica, k.miejscowosc;


-- ZADANIE 4 --
-- Napisz zapytanie w języku SQL wyświetlające informacje na temat pudełek i ich zawartości
-- (nazwa pudełka, nazwa czekoladki, liczba sztuk):

-- 4.1  wszystkich pudełek, (czy typ joina tutaj jest wazny???)
SELECT distinct on(p.nazwa) p.nazwa, cz.nazwa, z.sztuk
from pudelka p
         left join zawartosc z on p.idpudelka = z.idpudelka
         JOIN czekoladki cz ON z.idczekoladki = cz.idczekoladki;


-- 4.2 pudełka o wartości klucza głównego heav
SELECT distinct on(p.nazwa) p.idpudelka, p.nazwa, cz.nazwa, z.sztuk
from pudelka p
         left join zawartosc z on p.idpudelka = z.idpudelka
         LEFT JOIN czekoladki cz ON z.idczekoladki = cz.idczekoladki
where p.idpudelka = 'heav';