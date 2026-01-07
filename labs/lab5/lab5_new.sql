set search_path to public, siatkowka;
--====================THEORY====================
--funkcje agregujace
--avg(x) - srednia arytm. przyjmuje tylko kolumne o typie numerycznym
--count(* | x) - jezeli x - liczba no null wierszy
--count(distinct x) zliczy unikatowe wierszy
--max(x), min(x) - min max ignorują null
--stddev(x) - odchylenie standardowe
--sum(x) - przyjmuje tylko kolumne o typie numerycznym
--variance(x)

--funkcje agregujące w where mogą wystąpic tylko w podzapytaniu!!!
select imie, nazwisko, punkty.punkty
from siatkarki natural join punkty
where punkty > (select avg(punkty) from punkty);

--jezeli jest group by funkcje agregujace działaja na kazdej grupie

--group by(arg1, arg2) - grupowanie wg kolumny arg1 a pozniej wewnątrz grup arg1 wg kolumny arg2

--kolejnosc pisania operacji
--select -> from -> where -> group by -> having -> order by | limit | offset;

--kolejnosc wykonania operacji
--from -> where -> group by -> having -> select -> order by | limit | offset;
--dlatego w where, group by i td nie dostępne aliasy ktore wprowadzamy w select
--ale w order by juz dostepne!

--========================================================

--1 Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--1.1 łącznej liczby czekoladek w bazie danych (w tabeli czekoladki),
select count(*)
from czekoladki;

--1.2 łącznej liczby czekoladek z nadzieniem (na 2 sposoby) - podpowiedź: count(*), count(nazwaKolumny),
select count(*)
from czekoladki
where nadzienie is not null;

select count(nadzienie)
from czekoladki;

--1.3 identyfikator pudełka, w którym jest najwięcej czekoladek
-- (jeśli jest kilka takich pudełek to wyświetl wszystkie - użyj podzapytania),
select idpudelka, sum(sztuk)
from zawartosc
group by idpudelka
having sum(sztuk) = (
    select max(suma_pudelka)
    from (
        select sum(sztuk) suma_pudelka
        from zawartosc
        group by idpudelka
         ) help
);

--1.4 identyfikatorów pudełek i łącznej liczby czekoladek zawartej w każdym z nich,
select idpudelka, sum(sztuk)
from zawartosc
group by idpudelka;

--1.5 identyfikatorów pudełek i łącznej liczby czekoladek bez orzechów zawartej w każdym z nich
-- (uwaga: należy pokazać 0 przy pudełkach mających tylko czekoladki z orzechami),
select p.idpudelka, sum(case when c.orzechy is null then z.sztuk else 0 end)
from pudelka p left join zawartosc z using (idpudelka)
               left join czekoladki c using (idczekoladki)
group by p.idpudelka;


--1.6 identyfikatorów pudełek i łącznej liczby czekoladek w mlecznej czekoladzie zawartej w każdym z nich
-- (uwaga: należy pokazać 0 przy pudełkach mających tylko czekoladki bez mlecznej czekolady).
select p.idpudelka, sum(case when c.czekolada <> 'mleczna' then 0 else z.sztuk end)
from pudelka p left join zawartosc z using (idpudelka)
               left join czekoladki c using (idczekoladki)
group by p.idpudelka;

select idpudelka, coalesce(help.liczba, 0)
from pudelka left join (select idpudelka, sum(sztuk) liczba
                        from zawartosc
                                 join czekoladki using (idczekoladki)
                        where czekolada = 'mleczna'
                        group by idpudelka
                        ) help using (idpudelka);

--========================================================

--2 Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--2.2 identyfikatorów i masy poszczególnych pudełek,
select idpudelka, sum(z.sztuk * c.masa)
from pudelka p join zawartosc z using (idpudelka)
             join czekoladki c using (idczekoladki)
group by idpudelka;

--2.3 identyfikatora i masy pudełka o największej masie (jeśli jest ich kilka, to wyświetl wszystkie),
with wagi as (select idpudelka, sum(z.sztuk * c.masa) suma
              from zawartosc z join czekoladki c using (idczekoladki)
              group by idpudelka
              )
select idpudelka, suma
from wagi
where wagi.suma = (select max(wagi.suma)
                   from wagi
                   );

--nie wiem co tutaj sie dzieje ale chyba dziala. to pierwsze jest lepsze, bo przenowsze obliczenie do osobnej tabeli
select p.idpudelka, sum(z.sztuk * c.masa)
from pudelka p join zawartosc z using (idpudelka)
               join czekoladki c using (idczekoladki)
group by idpudelka
having sum(z.sztuk * c.masa) = (select max(help.suma)
                                from (select sum(z.sztuk * c.masa) suma
                                      from pudelka p join zawartosc z using (idpudelka)
                                                     join czekoladki c using (idczekoladki)
                                      group by idpudelka) help
                                );

--to chyba przejdzie pod warunkiem, ze jest tylko jedno pudełko z max wagą
select idpudelka, sum(zawartosc.sztuk * czekoladki.masa) waga
from zawartosc join czekoladki using (idczekoladki)
group by idpudelka
order by waga desc
limit 1;

--========================================================

--3 Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--3.1 liczby zamówień na poszczególne dni,
select datarealizacji, count(*) liczba_zamowien
from zamowienia
group by datarealizacji
order by datarealizacji;

--3.2 łącznej liczby wszystkich zamówień,
select count(*)
from zamowienia;

--3.3 łącznej wartości wszystkich zamówień,
select sum(a.sztuk * p.cena) laczna_wartosc
from artykuly a join pudelka p on a.idpudelka = p.idpudelka;

--3.4 identyfikatorów klientów, liczby złożonych przez nich zamówień i łącznej wartości
-- złożonych przez nich zamówień (uwaga: należy pokazać 0 przy klientach, którzy nie złożyli żadnych zamówień).
with z as (
    select idklienta, count(*) liczba_z
    from zamowienia
    group by idklienta
), w as (
    select idklienta, sum(a.sztuk * p.cena) wartosc_z
    from zamowienia zm
        join artykuly a on zm.idzamowienia = a.idzamowienia
        join pudelka p on a.idpudelka = p.idpudelka
    group by idklienta
)
select idklienta, liczba_z, coalesce(wartosc_z, 0)
from klienci
    left join z using (idklienta)
    left join w using (idklienta);


select k.idklienta, count(distinct z.idzamowienia), coalesce(sum(a.sztuk * p.cena), 0)
from klienci k
    left join zamowienia z on k.idklienta = z.idklienta
    left join artykuly a on z.idzamowienia = a.idzamowienia
    left join pudelka p on a.idpudelka = p.idpudelka
group by k.idklienta
order by k.idklienta;

--========================================================

--4 Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--4.1 identyfikatora czekoladki, która występuje w największej liczbie pudełek,
select idczekoladki, count(*) as liczba
from zawartosc
group by idczekoladki
order by liczba desc
limit 1;

-- 4.2 identyfikatora pudełka, które zawiera najwięcej czekoladek bez orzechów,
select z.idpudelka, count(*) as liczba
from zawartosc z join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.orzechy is null
group by z.idpudelka
order by liczba desc
limit 1;

select z.idpudelka
from zawartosc z join czekoladki cz on z.idczekoladki = cz.idczekoladki
where cz.orzechy is null
group by z.idpudelka
having sum(z.sztuk) = (select max(liczby.liczba)
                       from (select sum(z.sztuk) as liczba
                            from zawartosc z join czekoladki cz on z.idczekoladki = cz.idczekoladki
                            where cz.orzechy is null
                            group by z.idpudelka) liczby

);

WITH xyz AS (
    SELECT zaw.idpudelka, SUM(zaw.sztuk) AS liczba
    FROM zawartosc zaw JOIN czekoladki cz USING(idczekoladki)
    WHERE cz.orzechy IS NULL
    GROUP BY zaw.idpudelka
)
SELECT idpudelka
FROM xyz
where liczba = (SELECT MAX(xyz.liczba) FROM xyz);


--4.3 identyfikatora czekoladki, która występuje w najmniejszej liczbie pudełek
-- (uwaga: może istnieć czekoladka, która nie występuje w żadnym pudełku),
with wystapienia as (
    select xui.idczekoladki, count(z.idczekoladki) liczba
    from czekoladki xui left join zawartosc z on xui.idczekoladki = z.idczekoladki
    group by xui.idczekoladki
)
select idczekoladki, liczba
from wystapienia
where liczba = (select min(wystapienia.liczba) from wystapienia);

--5 Napisz zapytanie w języku SQL wyświetlające informacje na temat:

--5.5 liczby zamówień na poszczególne kwartały,


