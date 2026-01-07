set search_path to public, siatkowka;
--====================THEORY====================
--exist

-- 1 Przeanalizuj poniższe zapytania i zinterpretuj ich znaczenie.
-- Zwróć uwagę na operatory w klauzuli where:

--top 3 najdroższe czekoladki
SELECT DISTINCT nazwa
FROM pudelka
         NATURAL JOIN zawartosc
WHERE idczekoladki
          IN (SELECT idczekoladki FROM czekoladki ORDER BY koszt LIMIT 3);

--najdroższa czekoladka
SELECT nazwa
FROM czekoladki
WHERE koszt = (SELECT MAX(koszt) FROM czekoladki);

--bez distinct jedna z czekoladek sie powtarza
SELECT p.nazwa, idpudelka
FROM (SELECT idczekoladki FROM czekoladki ORDER BY koszt LIMIT 3)
         AS ulubioneczekoladki
         NATURAL JOIN zawartosc
         NATURAL JOIN pudelka p;

--wszystkie czekoladka i max cena
SELECT nazwa, koszt, (SELECT MAX(koszt) FROM czekoladki) AS MAX
FROM czekoladki;

-- 2 Napisz zapytanie wyświetlające informacje na temat klientów (nazwa, ulica, miejscowość),
-- używając odpowiedniego operatora in/not in/exists/any/all, którzy:
-- 2.1 złożyli zamówienia z datą realizacji 12 listopada br.,
-- moja wersja
select distinct k.nazwa, k.ulica, k.miejscowosc
from klienci k
         join zamowienia z on k.idklienta = z.idklienta
where z.idzamowienia in (select idzamowienia
                         from zamowienia
                         where date_part('year', datarealizacji) = date_part('year', current_date)
                           and date_part('month', datarealizacji) = 11
                           and date_part('day', z.datarealizacji) = 12);
--werska Gemini
SELECT nazwa,
       ulica,
       miejscowosc
FROM klienci
WHERE idklienta IN (SELECT idklienta
                    FROM zamowienia
                    WHERE date_part('month', datarealizacji) = 11
                      AND date_part('day', datarealizacji) = 12
                      AND date_part('year', datarealizacji) = date_part('year', current_date));


--4. zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia,
select nazwa, ulica, miejscowosc
from klienci
where idklienta in (select idklienta
                    from zamowienia z
                             join artykuly a using (idzamowienia)
                             join pudelka p using (idpudelka)
                    where p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna')
                      and a.sztuk >= 2);

--6 złożyli przynajmniej jedno zamówienie,
--exist
select nazwa, ulica, miejscowosc
from klienci k
where exists (select 1
              from zamowienia
              where zamowienia.idklienta = k.idklienta);

--in
select nazwa, ulica, miejscowosc
from klienci
where idklienta in (select idklienta
                    from zamowienia);


-- 7. nie złożyli żadnych zamówień.
select nazwa, ulica, miejscowosc
from klienci k
where not exists (select 1
                  from zamowienia
                  where zamowienia.idklienta = k.idklienta);

select nazwa, ulica, miejscowosc
from klienci
where idklienta not in (select idklienta
                        from zamowienia);

