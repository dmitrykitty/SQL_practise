set search_path to public, siatkowka;
--====================THEORY====================
--exist


--any kwantyfikator E
--x > ANY (a, b, c) == (x > a) or (x > b) or (x > c)
--x = ANY (a, b, c) == x in (a, b, c)

--all kwantyfikator V
--x > ALL (a, b, c) == (x > a) and (x > b) and (x > c)
--x != ALL (a, b, c) == x not in (a, b, c)

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

--2.2 złożyli zamówienia z datą realizacji w listopadzie br.,
select nazwa,
       ulica,
       miejscowosc
FROM klienci
where idklienta = any (select idklienta
                       from zamowienia
                       where date_part('year', datarealizacji) = date_part('year', current_date)
                         and date_part('month', datarealizacji) = 11);


--2.3 zamówili pudełko Kremowa fantazja lub Kolekcja jesienna,
select nazwa,
       ulica,
       miejscowosc
FROM klienci
where idklienta in (select idklienta
                    from zamowienia z
                             join artykuly a using (idzamowienia)
                             join pudelka p using (idpudelka)
                    where p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna'));


--2.4 zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia,
select nazwa, ulica, miejscowosc
from klienci
where idklienta in (select idklienta
                    from zamowienia z
                             join artykuly a using (idzamowienia)
                             join pudelka p using (idpudelka)
                    where p.nazwa in ('Kremowa fantazja', 'Kolekcja jesienna')
                      and a.sztuk >= 2);

--2.5 zamówili pudełka, które zawierają czekoladki z migdałami,
select nazwa, ulica, miejscowosc
from klienci k
where exists(select 1
             from zamowienia z
                      join artykuly a using (idzamowienia)
                      join zawartosc zw using (idpudelka)
                      join czekoladki cz using (idczekoladki)
             where k.idklienta = z.idklienta
               and cz.orzechy = 'migdały');

select nazwa, ulica, miejscowosc
from klienci k
where k.idklienta = any (select z.idklienta
                         from zamowienia z
                                  join artykuly a using (idzamowienia)
                                  join zawartosc zw using (idpudelka)
                                  join czekoladki cz using (idczekoladki)
                         where cz.orzechy = 'migdały');

--2.6 złożyli przynajmniej jedno zamówienie,
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


-- 2.7 nie złożyli żadnych zamówień.
select nazwa, ulica, miejscowosc
from klienci k
where not exists (select 1
                  from zamowienia
                  where zamowienia.idklienta = k.idklienta);

--in
select nazwa, ulica, miejscowosc
from klienci
where idklienta not in (select idklienta
                        from zamowienia);

--all
select nazwa, ulica, miejscowosc
from klienci
where idklienta != all (select idklienta
                        from zamowienia);


-- 3 Napisz zapytanie wyświetlające informacje na temat pudełek z czekoladkami (nazwa, opis, cena),
-- używając odpowiedniego operatora, np. in/not in/exists/any/all, które:

-- 3.1 zawierają czekoladki o wartości klucza głównego D09
select nazwa, opis, cena
from pudelka
where idpudelka in (select idpudelka
                    from zawartosc
                    where idczekoladki = 'D09');


select nazwa, opis, cena
from pudelka p
where exists(select idpudelka
             from zawartosc z
             where idczekoladki = 'D09'
               and p.idpudelka = z.idpudelka);


-- 3.2 zawierają czekoladki Gorzka truskawkowa,
select nazwa, opis, cena
from pudelka
where idpudelka = any (select idpudelka
                       from zawartosc
                                join czekoladki cz using (idczekoladki)
                       where cz.nazwa = 'Gorzka truskawkowa');


--3.3 zawierają przynajmniej jedną czekoladkę, której nazwa zaczyna się na S
select nazwa, opis, cena
from pudelka p
where exists (select 1
              from zawartosc z
                       join czekoladki cz using (idczekoladki)
              where p.idpudelka = z.idpudelka
                and cz.nazwa like 'S%');


--3.4 zawierają przynajmniej 4 sztuki czekoladek jednego gatunku (o takim samym kluczu głównym),
select nazwa, opis, cena
from pudelka p
where 4 <= any (select sztuk
                from zawartosc z
                where p.idpudelka = z.idpudelka);

select nazwa, opis, cena
from pudelka p
where exists(select 1
             from zawartosc z
             where z.idpudelka = p.idpudelka
               and z.sztuk >= 4);


--3.5 zawierają co najmniej 3 sztuki czekoladki Gorzka truskawkowa,
select nazwa, opis, cena
from pudelka p
where exists(select 1
             from zawartosc z
                      join czekoladki cz using (idczekoladki)
             where z.idpudelka = p.idpudelka
               and z.sztuk >= 3
               and cz.nazwa = 'Gorzka truskawkowa');

--3.6 zawierają czekoladki z nadzieniem truskawkowym, skip, not interesting

--3.7 nie zawierają czekoladek w gorzkiej czekoladzie
select nazwa, opis, cena
from pudelka p
where idpudelka != all (select idpudelka
                        from zawartosc
                                 join czekoladki using (idczekoladki)
                        where czekoladki.czekolada = 'gorzka');

--3.9 zawierają przynajmniej jedną czekoladkę bez nadzienia.
select nazwa, opis, cena
from pudelka p
where idpudelka = any (select idpudelka
                       from zawartosc
                                join czekoladki using (idczekoladki)
                       where czekoladki.nadzienie is null);



-- 4 Wyświetl identyfikator i nazwę pudełka oraz liczbę czekoladek, dla:
-- 4.1 pudełka o największej liczbie czekoladek (bez użycia klauzuli limit),
select p.idpudelka, p.nazwa, sum(z.sztuk)
from pudelka p
         natural join zawartosc z
group by idpudelka, nazwa
having sum(z.sztuk) >= all (select sum(sztuk)
                            from zawartosc
                            group by idpudelka);


with sumy as (select idpudelka, sum(sztuk) suma_sztuk
              from zawartosc
              group by idpudelka)
select p.idpudelka, p.nazwa, s.suma_sztuk
from pudelka p
         join sumy s using (idpudelka)
where s.suma_sztuk = (select max(suma_sztuk) from sumy);


--4.2 pudełka o największej liczbie czekoladek z orzechami (bez użycia klauzuli limit),
select p.idpudelka, p.nazwa, sum(sztuk) suma_sztuk
from pudelka p
         join zawartosc z using (idpudelka)
         join czekoladki cz using (idczekoladki)
where cz.orzechy is not null
group by p.idpudelka, p.nazwa
having sum(sztuk) >= all (select sum(zawartosc.sztuk)
                          from zawartosc
                                   join czekoladki using (idczekoladki)
                          where czekoladki.orzechy is not null
                          group by zawartosc.idpudelka);


with sumy as (select zawartosc.idpudelka, sum(zawartosc.sztuk) suma_sztuk
              from zawartosc
                       join czekoladki using (idczekoladki)
              where czekoladki.orzechy is not null
              group by zawartosc.idpudelka)
select p.idpudelka, p.nazwa, s.suma_sztuk
from pudelka p
         join sumy s using (idpudelka)
where s.suma_sztuk = (select max(suma_sztuk) from sumy);

--4.3 pudełka, w którym liczba czekoladek jest powyżej średniej.
with sumy as (select zawartosc.idpudelka, sum(zawartosc.sztuk) suma_sztuk
              from zawartosc
                       join czekoladki using (idczekoladki)
              where czekoladki.orzechy is not null
              group by zawartosc.idpudelka)
select p.idpudelka, p.nazwa, s.suma_sztuk
from pudelka p
         join sumy s using (idpudelka)
where s.suma_sztuk > (select avg(suma_sztuk) from sumy);


--4.4 pudełka, które aktualnie jest najczęściej zamawiane (bez użycia klauzuli limit).
with liczba_zamowien as (select idpudelka, count(idzamowienia) liczba
                         from artykuly
                                  join pudelka using (idpudelka)
                         group by idpudelka),
     sumy as (select zawartosc.idpudelka, sum(zawartosc.sztuk) suma_sztuk
              from zawartosc
              group by zawartosc.idpudelka)
select p.idpudelka, p.nazwa, s.suma_sztuk
from pudelka p
         join liczba_zamowien lz using (idpudelka)
         join sumy s using (idpudelka)
where lz.liczba = (select max(liczba) from liczba_zamowien);


SELECT p.idpudelka,
       p.nazwa,
       (SELECT SUM(sztuk) FROM zawartosc WHERE idpudelka = p.idpudelka) AS liczba_czekoladek
FROM pudelka p
         JOIN artykuly a USING (idpudelka)
GROUP BY p.idpudelka, p.nazwa
HAVING COUNT(a.idzamowienia) >= ALL (SELECT COUNT(idzamowienia)
                                     FROM artykuly
                                     GROUP BY idpudelka);


