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


SELECT z.datarealizacji, z.idzamowienia
FROM zamowienia z
WHERE z.idklienta IN (SELECT idklienta FROM klienci WHERE nazwa ILIKE '%Antoni');



SELECT k.nazwa, z.datarealizacji, z.idzamowienia
FROM zamowienia z
         JOIN klienci k ON z.idklienta = k.idklienta
WHERE k.nazwa ILIKE '%Antoni';


SELECT z.datarealizacji, z.idzamowienia, k.ulica
FROM zamowienia z
         JOIN klienci k ON z.idklienta = k.idklienta
WHERE k.ulica ILIKE '%/%';

SELECT DISTINCT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji
FROM klienci k
         JOIN zamowienia z on k.idklienta = z.idklienta
where z.datarealizacji > (SELECT now() - INTERVAL '15 years');



SELECT DISTINCT k.idklienta, k.nazwa, k.ulica, k.miejscowosc, z.datarealizacji

FROM klienci k
         JOIN zamowienia z on k.idklienta = z.idklienta
        JOIN pudelka p on z.idzp = p.i




