set search_path to kolokwium;

-- 1. (5p.) Napisz zapytanie SQL pobierające nazwy dań oraz ich gramaturę. Należy spełnić wszystkie
-- poniższe warunki:
-- • Pobierz tylko dania których kaloryczność nie jest mniejszcza od 300 kcal i jednocześnie nie jest wyższa
-- niż 500 kcal.
-- • Pobrana gramatura powinna być wyrażona w dekagramach jako liczba całkowita (1dag = 10g) - użyj
-- w tym celu funkcji FLOOR(jakaś_liczba), aby zaokrąglić liczbę w dół.
-- • Dania powinny być posortowane po nazwach rosnąco. Jeżeli dwa dania mają taką samą nazwę to
-- należy posortować je według gramatury malejąco
select nazwa, floor(gramatura::numeric / 10)
from dania
where kalorycznosc between 300 and 500
order by nazwa, gramatura desc;

--========================================================
-- 2. (5p.) Korzystając z jednego z operatorów UNION/INTERSECT/EXCEPT, napisz zapytanie SQL pobierające z
-- bazy id diet bezglutenowych, na które złożono zamówienia w grudniu dowolnego roku.
select id_diety
from diety
where gluten = false
intersect
select id_diety
from zamowienia
where date_part('month', data_zlozenia) = 12;

--========================================================
--3. (5p.) Klient, który złożył zamówienie nr 20 narzeka na na niską liczbę śniadań wysokokalorycznych
-- w ofercie. Napisz zapytanie SQL, które pobierze nazwy wszystkich posiłków śniadaniowych o kaloryczności
-- wyższej niż 800 kcal, oferowanych (tabela dostepnosc) w okresie objętym jego zamówieniem,
-- lecz niewybranych przez niego.
select dn.nazwa
from zamowienia zam
    join diety di on zam.id_diety = di.id_diety
    join dostepnosc dost on (
        di.id_diety = dost.id_diety and
        dost.data_dostawy between zam.dostawy_od and zam.dostawy_do and
        pora_dnia = 'sniadanie'
    )
    join dania dn on dost.id_dania = dn.id_dania
    left join wybory wb on (
        zam.id_zamowienia = wb.id_zamowienia and
        wb.id_dania = dost.id_dania
    )
where zam.id_zamowienia = 20 and
      kalorycznosc > 800 and
      wb.id_zamowienia is null;

select dn.nazwa --wszystkie zamowienia >800 kkal z zadanego terminu sniadania
from zamowienia zam
    join diety di on zam.id_diety = di.id_diety
    join dostepnosc dost on di.id_diety = dost.id_diety
    join dania dn on dost.id_dania = dn.id_dania
where zam.id_zamowienia = 20 and
      dost.data_dostawy BETWEEN zam.dostawy_od AND zam.dostawy_do and
      dost.pora_dnia = 'sniadania' and
      dn.kalorycznosc > 800

except

select dn.nazwa
from zamowienia zam
    join wybory wb on zam.id_zamowienia = wb.id_zamowienia
    join dania dn on wb.id_dania = dn.id_dania
where zam.id_zamowienia = 20;

--========================================================
--4. (5p.) Napisz zapytanie SQL pobierające łączny zysk uzyskany przez firmę w dniu 1 grudnia 2022. Aby
-- obliczyć zysk należy od sumy wartości zamówień na ten dzień (suma z cena_dzien x liczba dostaw każdej
-- diety) odjąć koszt produkcji wszystkich dań wybranych w tym dniu (uwaga: jedno danie może być wybrane
-- przez wielu klientów). Należy uwzględnić, że we wskazanym terminie mogło nie być żadnych zamówień -
-- wówczas zysk powinien wynieść 0.
with suma_wartosci as (
    select sum(di.cena_dzien)
    from zamowienia z
        join diety di on z.id_diety = di.id_diety
    where '2022-12-01'::date between z.dostawy_od and z.dostawy_do
), koszt_dan as (
    select sum(dn.koszt_produkcji)
    from dania dn
        join wybory wb on dn.id_dania = wb.id_dania
    where wb.data_dostawy = '2022-12-01'
)
select coalesce(suma_wartosci - koszt_dan, 0) as zysk
from suma_wartosci, koszt_dan; --lub suma wartosic cross joim koszt

select (select coalesce(sum(di.cena_dzien), 0)
        from zamowienia z
                 join diety di on z.id_diety = di.id_diety
        where '2022-12-01'::date between z.dostawy_od and z.dostawy_do
        ) -
       (select coalesce(sum(dn.koszt_produkcji), 0)
        from dania dn
                 join wybory wb on dn.id_dania = wb.id_dania
        where wb.data_dostawy = '2022-12-01')
    as zysk_dnia;

-- 4. (5p.) Napisz zapytanie SQL pobierające łączny zysk uzyskany przez firmę w dniu 1 grudnia 2022. Aby
-- obliczyć zysk należy od sumy wartości zamówień na ten dzień (suma z cena_dzien x liczba dostaw każdej
-- diety) odjąć koszt produkcji wszystkich dań wybranych w tym dniu (uwaga: jedno danie może być wybrane
-- przez wielu klientów). Należy uwzględnić, że we wskazanym terminie mogło nie być żadnych zamówień -
-- wówczas zysk powinien wynieść 0.
with zysk as (
    select coalesce(sum(di.cena_dzien), 0)
    from zamowienia zam
        join diety di on zam.id_diety = di.id_diety
    where '2022-12-01'::date between  zam.dostawy_od and zam.dostawy_do
), koszt as (
    select coalesce(sum(koszt_produkcji), 0)
    from wybory wb
        join dania dn on wb.id_dania = dn.id_dania
    where wb.data_dostawy = '2022-12-01'
)
select zysk - koszt as wynik
from zysk, koszt;

--========================================================

-- 5. (5p.) Napisz zapytanie, które wybierze (INSERT INTO wybory ...) śniadanie o najniższej kaloryczności
-- dla zamówienia o ID 20 na dzień dostawy 1 grudnia 2022. Jest tylko jedno takie śniadanie.
insert into wybory (id_zamowienia, id_dania, data_dostawy)
select 20, dn.id_dania, '2022-12-01'
from zamowienia zam
    join dostepnosc dost on zam.id_diety = dost.id_diety
    join dania dn on dost.id_dania = dn.id_dania
where dost.pora_dnia = 'sniadanie' and
      zam.id_zamowienia = 20 and
      dost.data_dostawy = '2022-12-01'::date
order by kalorycznosc
limit 1;

--5. (5p.) Klienci, który złożył zamówienie nr 20, chciałby zmienić swój dokonany już wybór obiadu na dzień
-- dostawy 1 grudnia 2022, na taki obiad, który ma najwyższą gramaturę. Jest tylko jeden taki obiad. Napisz
-- zapytanie (UPDATE wybory ...), które to umożliwi.
update wybory
set id_dania = (select d.id_dania
                from zamowienia zam
                    join dostepnosc dost on zam.id_diety = dost.id_diety
                    join dania d on dost.id_dania = d.id_dania
                where zam.id_zamowienia = 20 and
                      dost.data_dostawy = '2022-12-01' and
                      dost.pora_dnia = 'obiad'
                order by d.gramatura desc
                limit 1
                )
where id_zamowienia = 20 and
      data_dostawy = '2022-12-01' and
      id_dania in (select dost.id_dania
                   from zamowienia zam
                            join dostepnosc dost on zam.id_diety = dost.id_diety
                   where zam.id_zamowienia = 20 and
                       dost.data_dostawy = '2022-12-01' and
                       dost.pora_dnia = 'obiad');
