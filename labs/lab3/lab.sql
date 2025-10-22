SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji BETWEEN '2025-11-12' AND '2025-11-20';


SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji BETWEEN '2025-11-12' AND '2025-11-20'
   OR (dataRealizacji BETWEEN '2025-12-15' AND '2025-12-20');

SELECT idzamowienia, datarealizacji
FROM zamowienia
WHERE datarealizacji BETWEEN '2025-12-01' AND '2025-12-31';

SELECT idZamowienia,
       dataRealizacji
FROM zamowienia
WHERE date_part('year', dataRealizacji) = date_part('year', CURRENT_DATE)
  AND date_part('month', dataRealizacji) = 11;


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
WHERE nazwa LIKE 'A%' OR nazwa LIKE 'B%' OR nazwa LIKE 'C%';



SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM czekoladki
WHERE nazwa ILIKE '%orzech%';


SELECT DISTINCT miejscowosc
FROM klienci
WHERE miejscowosc LIKE '% %';


SELECT nazwa, telefon
FROM klienci
WHERE telefon LIKE '___ ___ __ __';


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






