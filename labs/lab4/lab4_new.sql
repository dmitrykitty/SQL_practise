set search_path to public, siatkowka;
--====================THEORY====================


--1 Porównaj wyniki poniższych zapytań:
SELECT k.nazwa
FROM klienci k; --wszystkie klienty (67 rows)

select z.idzamowienia
from zamowienia z; --(145 rows)

SELECT k.nazwa, z.idzamowienia --iloczyn kartezjanski zamowienia x klienci (145 x 67) = 9715 rows
FROM klienci k,
     zamowienia z;

--tutaj tworzy sie iloczyn kartezjanski i dalej on sie filtruje wg warunku
--nie zaleca sie to stosowac, bo jest przestarzałe
SELECT k.nazwa, z.idzamowienia --przypisujemy kazdemu zamowieniu klienta (145 rows = zamowienia rows)
FROM klienci k,
     zamowienia z
WHERE z.idklienta = k.idklienta;

--szuka wspolnych kolumn, jezeli jest jedna lub wspole tylko te, wg ktorych chcemy łączyc - git
--nie najlepiej sie sprawdza w dłuższym czasie (jak dodam do obu kolumn cos pozniej - wynik sie zmieni)
SELECT k.nazwa, z.idzamowienia --to samo, co zwykly inner join pod warunkiem rownosci idklienta(145 rows)
FROM klienci k
         NATURAL JOIN zamowienia z;

--najbardziej elastyczny - pozwala łączyc tabeli wg roznych nazw kolumn
SELECT k.nazwa, z.idzamowienia --te same 145 rows
FROM klienci k
         JOIN zamowienia z
              ON z.idklienta = k.idklienta;

--to samo, co wyzej, ale nazwa kolumn ma byc taka sama
SELECT k.nazwa, z.idzamowienia --i tez ma byc dokładnie to samo (145 rows)
FROM klienci k
         JOIN zamowienia z
              USING (idklienta);

--==============================================================

--2 Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień (data realizacji, idzamowienia), które:

--2.1 zostały złożone przez klienta, który ma na imię Antoni,
--tutaj wspolna kolumna tylko jedna i ma taką samą nazwe, wiec pasuje join on, join using oraz natural join
select z.datarealizacji, z.idzamowienia
from klienci k join zamowienia z using (idklienta)
where k.nazwa ilike '% antoni';

select z.datarealizacji, z.idzamowienia
from klienci k natural join zamowienia z
where k.nazwa ilike '% antoni';

--2.2 zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica),
select z.datarealizacji, z.idzamowienia, k.ulica
from klienci k join zamowienia z on z.idklienta = k.idklienta
where k.ulica similar to '% [0-9]{1,}/[0-9]{1,}';

--2.3 zostały złożone przez klienta z Krakowa do realizacji w listopadzie bieżącego roku.
--btw uwielbiam pracę z datami
select z.datarealizacji, z.idzamowienia
from klienci k join zamowienia z on z.idklienta = k.idklienta
where date_part('year', z.datarealizacji) = date_part('year', current_date) and
      date_part('month', z.datarealizacji) = 11 and
      k.miejscowosc similar to '[Kk]rak[oó]w';

--==============================================================

--3 Napisz zapytanie w języku SQL wyświetlające informacje
-- na temat klientów (idklienta, nazwa, ulica, miejscowość), którzy:

--3.1 złożyli zamówienia z datą realizacji nie starszą niż sprzed piętnastu lat,
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z using(idklienta)
where datarealizacji >= current_date - interval '15 years';

--zbyt skomplikowane, ale dl przypomnienia funkcji age() moze byc
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z using(idklienta)
where age(datarealizacji , current_date - interval '15 years') < interval '15 years';

--3.2 zamówili pudełko Kremowa fantazja lub Kolekcja jesienna,
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z on k.idklienta = z.idklienta
               join artykuly a on z.idzamowienia = a.idzamowienia
               join pudelka p on a.idpudelka = p.idpudelka
where p.nazwa in ('Kremowa fantazja','Kolekcja jesienna');

--3.3 złożyli przynajmniej jedno zamówienie,
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z using(idklienta);

--3.4 nie złożyli żadnych zamówień,
--pierwsze, co przyszło do głowy
select idklienta, nazwa, ulica, miejscowosc
from klienci
where idklienta in (select idklienta
                    from klienci
                    except
                    select idklienta
                    from zamowienia);

--prostsze z uzyciem outer joina
select k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from zamowienia z left join klienci k on k.idklienta = z.idklienta
where z.idzamowienia is null;

--3.5  złożyli zamówienia z datą realizacji w listopadzie bieżącego roku,
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z on z.idklienta = k.idklienta
where date_part('year', z.datarealizacji) = date_part('year', current_date) and
    date_part('month', z.datarealizacji) = 11;

--3.6 zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia,
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z on k.idklienta = z.idklienta
               join artykuly a on z.idzamowienia = a.idzamowienia
               join pudelka p on a.idpudelka = p.idpudelka
where a.sztuk >= 2 and
      p.nazwa in ('Kremowa fantazja','Kolekcja jesienna');

--3.7 zamówili pudełka, które zawierają czekoladki z migdałami.
select distinct k.idklienta, k.nazwa, k.ulica, k.miejscowosc
from klienci k join zamowienia z on k.idklienta = z.idklienta
               join artykuly a on z.idzamowienia = a.idzamowienia
               join pudelka p on a.idpudelka = p.idpudelka
               join zawartosc zw on p.idpudelka = zw.idpudelka
               join czekoladki cz on zw.idczekoladki = cz.idczekoladki
where cz.orzechy = 'migdały';

--==============================================================

--4 Napisz zapytanie w języku SQL wyświetlające informacje na temat pudełek i
-- ich zawartości (nazwa pudełka, nazwa czekoladki, liczba sztuk):
select p.nazwa nazwa_pudekla, cz.nazwa nazwa_czekoladki, z.sztuk
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki;
