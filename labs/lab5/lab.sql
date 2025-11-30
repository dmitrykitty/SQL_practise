set search_path to public, siatkowka;

--ZADANIE 1--
--Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--1.1 łącznej liczby czekoladek w bazie danych (w tabeli czekoladki),
select count(idczekoladki)
from czekoladki;

--1.2 łącznej liczby czekoladek z nadzieniem (na 2 sposoby) - podpowiedź: count(*), count(nazwaKolumny),
select count(*)
from czekoladki
where nadzienie is not null;

select count(idczekoladki)
from czekoladki
where nadzienie is not null;

--1.3 identyfikator pudełka, w którym jest najwięcej czekoladek
-- (jeśli jest kilka takich pudełek to wyświetl wszystkie - użyj podzapytania)
with sumaczekoladek as (select idpudelka, sum(sztuk) as suma
                        from zawartosc
                        group by idpudelka)
select sc.idpudelka, sc.suma
from sumaczekoladek sc
where suma = (select max(suma) from sumaczekoladek);

--ZADANIE 2--
--Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--2.1 identyfikatorów i masy poszczególnych pudełek,
select z.idpudelka, sum(c.masa) suma
from zawartosc z
         join czekoladki c on z.idczekoladki = c.idczekoladki
group by z.idpudelka;

--2.2 identyfikatora i masy pudełka o największej masie (jeśli jest ich kilka, to wyświetl wszystkie),
with masypudelek as (select z.idpudelka, sum(c.masa) as suma
                     from zawartosc z
                              join czekoladki c on z.idczekoladki = c.idczekoladki
                     group by z.idpudelka)
select idpudelka, suma
from masypudelek
where suma = (select max(suma) from masypudelek);

--ZADANIE 3--
--Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--3.1 liczby zamówień na poszczególne dni,
SELECT datarealizacji,
       COUNT(idzamowienia) AS liczba_zamowien
FROM zamowienia
GROUP BY datarealizacji
ORDER BY datarealizacji;

--łącznej liczby wszystkich zamówień,
select count(idzamowienia)
from zamowienia;
