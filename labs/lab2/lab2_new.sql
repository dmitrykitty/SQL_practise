set search_path to public, siatkowka;
--====================THEORY====================
--select distinct - unique records
--select distinct on (atrybut1, atrubut2, ...n) - unikatowe tylko wg jednej lub n kolomn

--jak mamy tablicze z liczb, uzywamy []
--select punkty[1] - wybierz pierwszą liczbę
--select punkty[1:3] - wybierz 1,2,3 liczby

--between a and b  <=> [a, b]
--not betweem a and b  <=> (-inf, a) and (b, +inf)

--offset 5 - ile pierwszych wynikow ma byc pominięto
--limit 5 - ile recordow wyswietlono

--order by cos desc (malejąco), rosnąco by default


--================================================

--1 Napisz zapytanie w języku SQL, które:

-- 1.1 wyświetla listę klientów (nazwa, ulica, miejscowość) posortowaną według nazw klientów,
select nazwa, ulica, miejscowosc
from klienci
order by nazwa;

--1.2 wyświetla listę klientów posortowaną malejąco według nazw miejscowości, a w ramach tej
-- samej miejscowości rosnąco według nazw klientów,
select *
from klienci
order by miejscowosc desc, nazwa;

--1.3 wyświetla listę klientów z Krakowa lub z Warszawy posortowaną malejąco według nazw miejscowości, a w ramach tej
-- samej miejscowości rosnąco według nazw klientów (zapytanie utwórz na dwa sposoby stosując w kryteriach or lub in).
select *
from klienci
where miejscowosc ilike 'kraków' or miejscowosc ilike 'warszawa'
order by miejscowosc desc, nazwa;

--II sposob z in
select *
from klienci
where miejscowosc in ('Kraków', 'Warszawa')
order by miejscowosc desc, nazwa;

--III sposob z uzyciem regex
select *
from klienci
where miejscowosc similar to '([Kk]rak[oó]w|[Ww]arszawa)'
order by miejscowosc desc, nazwa;

--1.4 wyświetla listę klientów posortowaną malejąco według nazw miejscowości,
select *
from klienci
order by miejscowosc desc;

--1.5 wyświetla listę klientów z Krakowa posortowaną według nazw klientów.
select *
from klienci
where miejscowosc ilike 'kraków'
order by nazwa;

--====================================================

--2 Napisz zapytanie w języku SQL, które:

--2.1 wyświetla nazwę i masę czekoladek, których masa jest większa niż 20 g,
select nazwa, masa
from czekoladki
where masa > 20;

--2.2 wyświetla nazwę, masę i koszt produkcji czekoladek, których masa jest większa niż 20 g
-- i koszt produkcji jest większy niż 25 gr,
select nazwa, masa, koszt
from czekoladki
where masa > 20 and koszt > 0.25;

--2.3 j.w. ale koszt produkcji musi być podany w groszach,
--kazdy wynik w złotych pomnożony razy 100
--opcjonalne rzutowanie na integer (:: ma wyzszy priorytet niz mnozenie)
select nazwa, masa, (koszt*100)::integer koszt_groszy
from czekoladki
where masa > 20 and koszt > 0.25;

--2.4 wyświetla nazwę oraz rodzaj czekolady, nadzienia i orzechów dla czekoladek,
-- które są w mlecznej czekoladzie i nadziane malinami lub są w mlecznej czekoladzie i nadziane truskawkami
-- lub zawierają orzechy laskowe, ale nie są w gorzkiej czekoladzie,
-- <>  <=>  !=  <=> not cos = czemus
select nazwa, czekolada, nadzienie, orzechy
from czekoladki
where (czekolada = 'mleczna' and nadzienie in ('truskawki', 'maliny') or
       czekolada <> 'gorzka' and orzechy = 'laskowe');

--2.5 wyświetla nazwę i koszt produkcji czekoladek, których koszt produkcji jest większy niż 25 gr,
select nazwa, koszt
from czekoladki
where koszt > 0.25;

--2.6 wyświetla nazwę i rodzaj czekolady dla czekoladek, które są w białej lub mlecznej czekoladzie.
select nazwa, czekolada
from czekoladki
where czekolada in ('biała', 'mleczna');

--===============================================

--3 Potraktuj PostgreSQL jak kalkulator i wyznacz:

--3.1 124 * 7 + 45,
select 124 * 7 + 45;

--3.2 2 ^ 20,
select pow(2, 20);

--3.3 √3
select sqrt(3);

--3.4 π
select pi();

--================================================

--4 Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
-- (IDCzekoladki, Nazwa, Masa, Koszt), których:

--4.1 masa mieści się w przedziale od 15 do 24 g,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 15 and 24;

--4.2 koszt produkcji mieści się w przedziale od 25 do 35 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where koszt between 0.25 and 0.35;

--4.3 masa mieści się w przedziale od 25 do 35 g lub koszt produkcji mieści się w przedziale od 15 do 24 gr.
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35 or koszt between 0.15 and 0.24;


--=================================================
--5 Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
-- (idCzekoladki, nazwa, czekolada, orzechy, nadzienie), które:

--5.1 zawierają jakieś orzechy,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where orzechy is not null;

--5.2 nie zawierają orzechów,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where orzechy is null;

--5.3 zawierają jakieś orzechy lub jakieś nadzienie,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where orzechy is not null or nadzienie is not null;

--5.4 są w mlecznej lub białej czekoladzie (użyj IN) i nie zawierają orzechów,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where czekolada in ('mleczna', 'biała') and orzechy is null;

--5.5 nie są ani w mlecznej ani w białej czekoladzie i zawierają jakieś orzechy lub jakieś nadzienie,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where czekolada not in ('mleczna', 'biała') and
      (orzechy is not null or nadzienie is not null);