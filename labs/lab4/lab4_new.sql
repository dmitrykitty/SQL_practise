set search_path to public, siatkowka;
--====================THEORY====================
--cross join (iloczyn kartezjanski)

--a join b on a.key=bkey --> w wyniku będzie dwie jednakowe kolumny z kluczami |a.key | b.key|
--a join b using(key) --> będzie jedna kolumna |key|
--a naturall join b --> tutaj tez w wyniku tylko jedna bez dublowania

--a left join b on a.key=b.key - wszystkie rekordy z lewej i tylko wybrane s prawej
--a left join b on a.key=b.key where b.key is null - np klienci(a) ktore nigdy nie zlozyli zamowien(b) ANTIJOIN
--a left join b on a.key=b.key AND b.key=... -mozna dodac warunek w on, to jest nie to samo, co where

--with help as (select ...) select ... - tworzenie tymczasowej tabeli

--==============================================================

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

--4.1 wszystkich pudełek,
--mi sie wydaje, ze poprawniej édzie tu uzyc left joina, bo chce nawet dostac takie rekordy nazwa_pud | null | null
select p.nazwa nazwa_pudekla, p.idpudelka,  cz.nazwa nazwa_czekoladki, z.sztuk
from pudelka p left join zawartosc z on p.idpudelka = z.idpudelka
               left join czekoladki cz on z.idczekoladki = cz.idczekoladki;

--4.2 pudełka o wartości klucza głównego heav,
--wazne rozumiec ze w wyniku beddzie nie jeden rekord, tylko tyle rekordow, ile jest czekoladek w wybranym pudełku
select p.nazwa nazwa_pudekla, p.idpudelka, cz.nazwa nazwa_czekoladki, z.sztuk
from pudelka p left join zawartosc z on p.idpudelka = z.idpudelka
               left join czekoladki cz on z.idczekoladki = cz.idczekoladki
where p.idpudelka = 'heav';

--4.3 pudełek, których nazwa zawiera słowo Kolekcja.
select p.nazwa nazwa_pudekla, p.idpudelka, cz.nazwa nazwa_czekoladki, z.sztuk
from pudelka p left join zawartosc z on p.idpudelka = z.idpudelka
               left join czekoladki cz on z.idczekoladki = cz.idczekoladki
where p.nazwa like '%Kolekcja%';

--==============================================================

--5 Napisz zapytanie w języku SQL wyświetlające informacje na temat pudełek z czekoladkami
--(idpudelka, nazwa, opis, cena), które (uwaga: może być konieczne użycie konstrukcji z poprzednich laboratoriów):

--W wynikach nie powinno być duplikatów.
--W każdym zapytaniu można dodać dodatkowe pola (poza danymi o pudełkach),
--które pozwolą sprawdzić, czy wynik jest poprawny.

--5.1 zawierają czekoladki o wartości klucza głównego d09
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
where z.idczekoladki = 'd09';

--5.2 zawierają przynajmniej jedną czekoladkę, której nazwa zaczyna się na S,
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nazwa like 'S%';

--ale jak dodamy kolumnę czekoldki, trzeba wskazac według ktorej kolumny będzie distinct
select distinct on (p.idpudelka, p.nazwa, p.opis, p.cena) p.idpudelka, p.nazwa, p.opis, p.cena, cz.nazwa
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nazwa like 'S%';

--5.3 zawierają przynajmniej 4 sztuki czekoladek jednego gatunku (o takim samym kluczu głównym),
--tutaj to samo, co ostantio - jak dodam z.sztuk - będę musiał wskazac distinct on
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
where sztuk >= 4;

--5.4 zawierają czekoladki z nadzieniem truskawkowym,
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nadzienie = 'truskawki';

--5.5 nie zawierają czekoladek w gorzkiej czekoladzie,
--tutaj wazne ze jak damy czekoada <> 'gorzka' dostaniemy pudełka, w ktorych mogą byc czekoladki gorzkie,
--ale co najmniej jedna nie będzie
--wiec trzeba zastosowac exceptu czy czegos innego (pudekła - pudełka z czekolodami gorzkimi)
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p
except
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.czekolada = 'gorzka';

--inne rozwiazanie, nawet szybsze od popszedniego
--wazne, do in mozemy przekazywac select tylko z jedna kolumną!!!
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p
where p.idpudelka not in (select z.idpudelka
                          from zawartosc z join czekoladki cz on z.idczekoladki = cz.idczekoladki
                          where cz.czekolada = 'gorzka'
                          );


--5.6 zawierają co najmniej 3 sztuki czekoladki Gorzka truskawkowa,
--chyba tu przejdzie bez d
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nazwa = 'Gorzka truskawkowa' and z.sztuk >= 3;

--5.7 nie zawierają czekoladek z orzechami, (tak samo jak w zadaniu 5.5 uzywajac except)
--nawet nie trzeba dawac distinct, bo union, except,intersect usuwaja dublicaty
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p
except
select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.orzechy is not null;


select p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p
where p.idpudelka not in (select z.idpudelka
                          from zawartosc z join czekoladki cz on z.idczekoladki = cz.idczekoladki
                          where cz.orzechy is not null
                          );

--i trzecia obcja ze strony Zaworskiego - uzycie join left and is null w where
--robimy left joina wszystkich pudełek z pudełkami, w ktorych wystepują czekoladki z orzechami
--i poprzez dodanie w where warunku filtrujemy w taki sposob, by pozbyc sie tych pudełek\
--MEGA WAZNE: zadzała tylko z on a.key=b.key bo tylko wtedy będą dublikaty kolumn z kluczem (nwm, u mnie dziala xD,
    --ale gemini mowi ze nie bedzie)

--pudełka left join pudełka z orzechami -> dostaniemy wszystkie pudełka, a w tych pudełkach gdzie
-- nie ma orzechow w idpudełka bedzie null i wybieramy akurat takie id
SELECT *
FROM
    pudelka p
        LEFT JOIN (
        SELECT z.idpudelka
        FROM
            zawartosc z
                JOIN czekoladki cz ON z.idczekoladki = cz.idczekoladki
        WHERE cz.orzechy IS NOT NULL
    ) j ON p.idpudelka = j.idpudelka
WHERE j.idpudelka IS NULL;

--5.8 zawierają czekoladki Gorzka truskawkowa,
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nazwa = 'Gorzka truskawkowa';

--5.9 zawierają przynajmniej jedną czekoladkę bez nadzienia.
select distinct p.idpudelka, p.nazwa, p.opis, p.cena
from pudelka p join zawartosc z on p.idpudelka = z.idpudelka
               join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.nadzienie is null;

--==============================================================

--6 Napisz poniższe zapytania w języku SQL:
--Uwaga: w powyższych zapytaniach można użyć samozłączeń (złączeń własnych).
--Wskazówka: Zapytanie w punkcie 2 można znacznie uprościć stosując konstrukcję z WITH.

--6.1 Wyświetl wartości kluczy głównych oraz nazwy czekoladek,
-- których koszt jest większy od kosztu czekoladki o wartości klucza głównego równej d08.
with czekoladka_d08 as (
    select koszt
    from czekoladki
    where idczekoladki = 'd08'
)
select idczekoladki, nazwa
from czekoladki
where koszt > (select * from czekoladka_d08);

--lub bez with
select idczekoladki, nazwa
from czekoladki
where koszt > (select koszt
               from czekoladki
               where idczekoladki = 'd08');

--6.2 Kto (identyfikator klienta, nazwa klienta) złożył zamówienie na dowolne pudełko, które zamawiała Górka Alicja.
with pudełka_alicji as (
    select a.idpudelka
    from klienci k join zamowienia z using (idklienta)
                   join artykuly a using (idzamowienia)
    where k.nazwa = 'Górka Alicja'
)
select distinct k.idklienta, k.nazwa
from klienci k join zamowienia z using (idklienta)
               join artykuly a using (idzamowienia)
where a.idpudelka in (select * from pudełka_alicji) and k.nazwa <> 'Górka Alicja'; --trzeba wykluczyc samą alicje

--troche inaczej napisana druga czesc zapytania
with pudełka_alicji as (
    select a.idpudelka
    from klienci k join zamowienia z using (idklienta)
                   join artykuly a using (idzamowienia)
    where k.nazwa = 'Górka Alicja'
)
select distinct k.idklienta, k.nazwa
from klienci k join zamowienia z using (idklienta)
               join artykuly a using (idzamowienia)
               join pudełka_alicji pa using (idpudelka)
where k.nazwa <> 'Górka Alicja'; --trzeba wykluczyc samą alicje

--6.3 Kto (identyfikator klienta, nazwa klienta)
-- złożył zamówienie na dowolne pudełko, które zamawiali klienci z Katowic.
with pudełka_z_katowic as (select a.idpudelka
                           from klienci k
                                    join zamowienia z using (idklienta)
                                    join artykuly a using (idzamowienia)
                           where k.miejscowosc = 'Katowice'
                           )
select distinct k.idklienta, k.nazwa
from klienci k join zamowienia z using (idklienta)
               join artykuly a using (idzamowienia)
               join pudełka_z_katowic pa using (idpudelka)
where k.miejscowosc <> 'Katowice';

--lub zamiast distinct mozna uzyc grupowania (do zadanie 6.2 tez)
with pudełka_z_katowic as (select a.idpudelka
                           from klienci k
                                    join zamowienia z using (idklienta)
                                    join artykuly a using (idzamowienia)
                           where k.miejscowosc = 'Katowice'
)
select k.idklienta, k.nazwa
from klienci k join zamowienia z using (idklienta)
               join artykuly a using (idzamowienia)
               join pudełka_z_katowic pa using (idpudelka)
where k.miejscowosc <> 'Katowice'
group by k.idklienta, k.nazwa;

--==============================================================

--7 Napisz zapytanie w języku SQL wyświetlające imię, nazwisko, identyfikator drużyny, pozycję na boisku

--7.1 i numer meczu dla zawodniczek, które zdobyły ponad 20 punktów i zostały MVP meczu,
--siatkarki
-- numer | iddruzyny | nazwisko | imie | pozycja
-- join statystyki (idmeczu | gosp | goscie | numer | iddruzyny) using(numer, iddruzyny) -->
-- numer | iddruzyny | nazwisko | imie | pozycja | idmeczu | gosp | goscie join punkty
--join punkty (numer | iddruzyny | idmeczu | punky | asy | bloki ) -->
--numer | iddruzyny | nazwisko | imie | pozycja | idmeczu | gosp | goscie | punky | asy | bloki
select s.imie, s.nazwisko, s.iddruzyny, s.pozycja, st.idmeczu
from siatkarki s join statystyki st using (numer, iddruzyny)
                 join punkty p using (numer, iddruzyny, idmeczu) --dołaczamy punkty konkretnej zawodniczki w konkretnym meczu
where punkty > 20;

--7.2 liczbę zdobytych punktów, identyfikator meczu i informację,
-- czy zawodniczka została MVP (kolumna z wartościami logicznymi), dla zawodniczek, które zdobyły ponad 20 punktów,
select s.imie, s.nazwisko, s.iddruzyny, p.punkty, p.idmeczu,
      (case when (st.numer is not null) then true else false end) isMVP
from siatkarki s join punkty p using (numer, iddruzyny)
                 left join statystyki st using (numer, iddruzyny, idmeczu)
where p.punkty > 20
order by p.idmeczu;

--7.3  identyfikator meczu dla zawodniczek z Łodzi, które zostały MVP meczu,
select s.imie, s.nazwisko, s.iddruzyny, s.pozycja, st.idmeczu
from druzyny d join siatkarki s using(iddruzyny)
               join statystyki st using(numer, iddruzyny)
where d.miasto = 'Łódź';

--7.4 i termin rozegrania meczu, dla zawodniczek, które zdobyły ponad 20 punktów i zostały MVP meczu,
select s.imie, s.nazwisko, s.iddruzyny, s.pozycja,  m.termin
from siatkarki s join statystyki st using (numer, iddruzyny) --zostały mvp
                 join punkty p using (idmeczu, numer, iddruzyny) --dla sprawdzenia >20
                 join mecze m using (idmeczu) --zeby dostac datę
where p.punkty > 20;

--7.5 i identyfikator meczu dla zawodniczek, które zostały MVP w fazie play off.
select s.imie, s.nazwisko, s.iddruzyny, s.pozycja, m.idmeczu
from siatkarki s join statystyki st using (numer, iddruzyny) --zostały mvp
                 join mecze m using (idmeczu) --zeby dostac mecz
                 join fazy f using (faza) --zeby dostac faze
where f.opis not like '%kolejka%';

--okropne...



