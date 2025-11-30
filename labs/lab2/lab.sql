SET search_path TO public, siatkowka;
-----------------ZADANIE 1 ------------------
--1.1 wyświetla listę klientów (nazwa, ulica, miejscowość) posortowaną według nazw klientów
SELECT nazwa, ulica, miejscowosc
FROM klienci
ORDER BY nazwa;

--1.2 wyświetla listę klientów posortowaną malejąco według nazw miejscowości,
-- a w ramach tej samej miejscowości rosnąco według nazw klientów
SELECT nazwa, ulica, miejscowosc
FROM klienci
ORDER BY miejscowosc DESC, nazwa;

select nullif(telefon, 'brak')
from klienci;
-- nullif -> dostaniemy null , jeżeli w kolumnie telefon podano wartość brak

select idmeczu,
       gospodarze,
       goscie as "goście",
       (
           case when (gospodarze[1] > goscie[1]) then 1 else 0 end +
           case when (gospodarze[2] > goscie[2]) then 1 else 0 end +
           case when (gospodarze[3] > goscie[3]) then 1 else 0 end +
           case when (gospodarze[4] > goscie[4]) then 1 else 0 end +
           case when (gospodarze[5] > goscie[5]) then 1 else 0 end
           )
              as "wygrane gospodarze",
       (
           case when (gospodarze[1] < goscie[1]) then 1 else 0 end +
           case when (gospodarze[2] < goscie[2]) then 1 else 0 end +
           case when (gospodarze[3] < goscie[3]) then 1 else 0 end +
           case when (gospodarze[4] < goscie[4]) then 1 else 0 end +
           case when (gospodarze[5] < goscie[5]) then 1 else 0 end
           )
              as "wygrane goście"
from statystyki;


select distinct imie, nazwisko
from siatkarki
ORDER BY imie;

select nazwisko || ' ' || imie as Siatkarki, pozycja
from siatkarki
where iddruzyny = 'rysice'
order by 1; --sortowanie po pierwszej kolumnie

select nazwisko || ' ' || substr(imie, 1, 1) || '.' as Siatkarki, --substr(skad, od jakiej pozycji, ile znakow)
       pozycja
from siatkarki
where iddruzyny = 'rysice'
order by 1;


select round(gospodarze[1]::numeric / goscie[1], 4) -- cast gospodarze[1] do typu floating poin numeric zeby było dzielenie
--typu (double)2/5. taki cast zadziała tylko w postgres
from statystyki;

SELECT round(cast(gospodarze[1] as numeric) / goscie[1], 4)
from statystyki;
--ten zadziała we wszystkich sql bazach


select distinct on (imie) imie, nazwisko --wg jakiej kolumny unikatowe wartosci DISTINCT ON (SMTH)
from siatkarki
ORDER BY imie;

SELECT sqrt(3);

SELECT pi();

select *
from statystyki;

select idmeczu, gospodarze[1], goscie[1] --gospodarze[1] - pierwszy wynik z tablicy w kolumnie gospodarze
from statystyki;

SELECT *
FROM siatkarki;


SELECT *
FROM siatkarki
WHERE not pozycja = 'libero';
--to samo
SELECT *
FROM siatkarki
WHERE pozycja != 'libero';
--to samo
SELECT *
FROM siatkarki
WHERE pozycja <> 'libero';

--wyrazenie1 is distinct from wyrazenie2 (wyrazenie 1 rozni sie od wyrazenia 2) -> mądry !=
-- a is not distinct frob b -> == (ale moze przyjmowac i operowac null, pozostałe operatory nie
--5 IS DISTINCT FROM NULL -> true
--null is distinct from null -> false

SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE czekolada NOT IN ('mleczna', 'biała')
  AND (orzechy IS NOT NULL OR nadzienie IS NOT NULL);
--mozna uzyc COALESCE ( funkcja zwraca pierwszą wartość z listy różną od null, wstawiając ją do najwyższego typu danych)
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE czekolada NOT IN ('mleczna', 'biała')
  AND coalesce(orzechy, nadzienie) IS NOT NULL;

-- SELECT
--   COALESCE(
--       telefon_komorkowy,
--       telefon_domowy,
--       telefon_sluzbowy,
--       'Brak danych'
--   ) AS najlepszy_kontakt
-- FROM klienci;

create view wystepy as
select *
from siatkarki
         natural join punkty;

select *
from wystepy;

select imie, nazwisko, iddruzyny, pozycja, idmeczu, punkty, asy, bloki
from wystepy
where punkty between 10 and  15 and bloki = 0;

-- a between x and y ≡ a >= x and a <= y
-- a not between x and y ≡ a < x or a > y