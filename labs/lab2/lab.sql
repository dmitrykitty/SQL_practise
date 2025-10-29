SET search_path TO public, siatkowka;

SELECT nazwa, ulica, miejscowosc
FROM klienci
ORDER BY nazwa;


SELECT nazwa, ulica, miejscowosc
FROM klienci
ORDER BY miejscowosc DESC, nazwa;


select distinct imie, nazwisko
from siatkarki
ORDER BY imie;

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

SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE czekolada NOT IN ('mleczna', 'biała')
  AND (orzechy IS NOT NULL OR nadzienie IS NOT NULL);

create view wystepy as
select *
from siatkarki natural join punkty;

select * from wystepy;

-- a between x and y ≡ a >= x and a <= y
-- a not between x and y ≡ a < x or a > y