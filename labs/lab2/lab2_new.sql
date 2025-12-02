set search_path to public, siatkowka;
--====================THEORY====================
--select distinct - unique records
--select distinct on (atrybut1, atrubut2, ...n) - unikatowe tylko wg jednej lub n kolomn
--a is distinct from b (to samo, co <>, ale działa też dla null, null is distinct from null -> false)

--jak mamy tablicze z liczb, uzywamy []
--select punkty[1] - wybierz pierwszą liczbę
--select punkty[1:3] - wybierz 1,2,3 liczby
--aby sprawdzic długość array - cardinality(kolumna) lub array_length(columna, wymiarowosc(1 dla zwykłych tablic))

--between a and b  <=> [a, b]
--not betweem a and b  <=> (-inf, a) and (b, +inf)

--offset 5 - ile pierwszych wynikow ma byc pominięto
--limit 5 - ile recordow wyswietlono

--order by cos desc (malejąco), rosnąco by default

-- <>  <=>  !=  <=> not cos = czemus

--view - nie zajmuje miejsca w pamięci, tylko wyswietla dane z istniejących tabel jak podano w select
--create view name_of_the_view as
--select cos...

--case when (warunek1 zwracałacy boolean) then wynik1
--     when (warunek2 zwracałacy boolean) then wynik2
--     ...
--     else wynikn
--     end opcjonalny alias

--konkatenacja: select nazwisko || ' ' || imie alias -> kolumna (Nazwisko Imie)
--rzutowanie amount::numeric (priorytet rzutowania wyżej niz +, * itd) lub cast(amount as numeric)
--nullif(numer, 'brak') -> zwroci numer, a jezeli 'brak' - zwroci null
--coalesce(numer, 'brak') -> zwroci numer, a jezeli numer null - zwroci 'brak'

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
where miejscowosc ilike 'kraków'
   or miejscowosc ilike 'warszawa'
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
where masa > 20
  and koszt > 0.25;

--2.3 j.w. ale koszt produkcji musi być podany w groszach,
--kazdy wynik w złotych pomnożony razy 100
--opcjonalne rzutowanie na integer (:: ma wyzszy priorytet niz mnozenie)
select nazwa, masa, (koszt * 100)::integer koszt_groszy
from czekoladki
where masa > 20
  and koszt > 0.25;

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
where masa between 25 and 35
   or koszt between 0.15 and 0.24;


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
where orzechy is not null
   or nadzienie is not null;

--5.4 są w mlecznej lub białej czekoladzie (użyj IN) i nie zawierają orzechów,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where czekolada in ('mleczna', 'biała')
  and orzechy is null;

--5.5 nie są ani w mlecznej ani w białej czekoladzie i zawierają jakieś orzechy lub jakieś nadzienie,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where czekolada not in ('mleczna', 'biała')
  and (orzechy is not null or nadzienie is not null);

--5.6 zawierają jakieś nadzienie,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nadzienie is not null;

--5.7 nie zawierają nadzienia,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nadzienie is null;

--5.8 nie zawierają orzechów ani nadzienia,
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where nadzienie is null
  and orzechy is null;

--są w mlecznej lub białej czekoladzie i nie zawierają nadzienia.
select idczekoladki, nazwa, czekolada, orzechy, nadzienie
from czekoladki
where czekolada in ('biała', 'mleczna')
  and nadzienie is null;

--=================================================

--6 Napisz zapytanie w języku SQL, które wyświetli informacje na temat czekoladek
-- (idCzekoladki, nazwa, masa, koszt), których:

--6.1 masa mieści się w przedziale od 15 do 24 g lub koszt produkcji mieści się w przedziale od 15 do 24 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where (masa between 15 and 24)
   or (koszt between 0.15 and 24);

--6.2 [masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr] lub
-- [masa mieści się w przedziale od 25 do 35 g i koszt produkcji mieści się w przedziale od 25 do 35 gr],
select idczekoladki, nazwa, masa, koszt
from czekoladki
where ((masa between 15 and 24) and (koszt between 0.15 and 0.24))
   or ((masa between 25 and 35) and (koszt between 0.25 and 0.35));

--6.3 masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where (masa between 15 and 24)
  and (koszt between 0.15 and 24);

--6.4 masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji nie mieści się w przedziale od 25 do 35 gr,
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35
  and koszt not between 0.25 and 0.35;

--6.5 masa mieści się w przedziale od 25 do 35 g,
-- ale koszt produkcji nie mieści się ani w przedziale od 15 do 24 gr, ani w przedziale od 25 do 35 gr
select idczekoladki, nazwa, masa, koszt
from czekoladki
where masa between 25 and 35
  and koszt not between 0.15 and 0.24
  and koszt not between 0.25 and 0.35;

--=================================================

--7 Wykonaj poniższą instrukcję dodającą do Twojej bazy widok wystepy.
--o joinach troche pozniej w lab4
create view wystepy as
select *
from siatkarki
         natural join punkty;

--Korzystając z widoku wystepy Napisz zapytanie w języku SQL,
-- które wyświetli informacje na temat zawodniczek
-- (imie, nazwisko, identyfikator drużyny, pozycja na boisku, identyfikator meczu,
-- liczba zdobytych punktów, liczba asów serwisowych, liczba punktów zdobytych blokiem), dla przypadków, gdy:

--7.1 zawodniczka zdobyła między 10, a 15 punktów, ale żadnego z nich blokiem,
select imie, nazwisko, iddruzyny, pozycja, punkty, asy, bloki
from wystepy
where punkty between 10 and 15
  and (bloki = 0 or bloki is null);

--7.2 zawodniczka zdobyła co najmniej 2 punkty i wszystkie punkty zdobyła blokiem,
select imie, nazwisko, iddruzyny, pozycja, punkty, asy, bloki
from wystepy
where punkty >= 2
  and bloki = punkty;

--7.3 zawodniczka zdobyła co najmniej 1 punkt i wszystkie punkty zdobyła blokiem lub z serwisu (as serwisowy)
--zalezy, czy suma punktow = bloki + asy, czy suma rowna sie bloki lub suma rowna sie asy. Wybrałem pierwsze
select imie, nazwisko, iddruzyny, pozycja, punkty, asy, bloki
from wystepy
where punkty >= 1
  and (bloki + asy = punkty);

--7.4  zawodniczka większość punktów w meczu zdobyła blokiem,
select imie, nazwisko, iddruzyny, pozycja, punkty, asy, bloki
from wystepy
where bloki > (punkty / 2);

--7.5 zawodniczka większość punktów zdobyła blokiem lub z serwisu (as serwisowy).
select imie, nazwisko, iddruzyny, pozycja, punkty, asy, bloki
from wystepy
where bloki + asy > punkty / 2;

--=================================================

--8 Wykonaj poniższą instrukcję dodającą do Twojej bazy widok mvp.
create view mvp as
select *
from siatkarki
         natural join statystyki;

--Korzystając z widoku mvp Napisz zapytanie w języku SQL, które wyświetli informacje na temat zawodniczek
-- (imie, nazwisko, identyfikator drużyny, pozycja na boisku, identyfikator meczu), dla przypadków, gdy:

--8.1 MVP została zawodniczka grająca na pozycji rozgrywającej i mecz miał dokładnie 4 sety,
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze
from mvp
where pozycja = 'rozgrywająca'
  and array_length(gospodarze, 1) = 4;

--uzycie innej funkcji dla sprawdzenia długosci array
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze
from mvp
where pozycja = 'rozgrywająca'
  and cardinality(gospodarze) = 4;

--8.2 MVP została zawodniczka grająca na pozycji rozgrywającej lub środkowej i mecz miał co najmniej 4 sety,
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze
from mvp
where pozycja similar to '(rozgrywająca|środkowa)'
  and array_length(gospodarze, 1) >= 4;

--8.3 MVP została zawodniczka grająca na pozycji rozgrywającej, środkowej lub libero i mecz miał dokładnie 3 sety,
-- ale ostatni set grano na przewagi,
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze
from mvp
where pozycja similar to '(rozgrywająca|środkowa|libero)'
  and array_length(gospodarze, 1) = 3
  and (gospodarze[3] > 25 or goscie[3] > 25);

--8.4 MVP została zawodniczka o imieniu Anna, Alicja lub Anastazja i goście wygrali w trzech setach,
--jezeli chodzi o co najmniej 3 setach wygranych ze wszystkich
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze, goscie
from mvp
where imie in ('Anna', 'Alicja', 'Anastazja')
  and ((case when (goscie[1] > gospodarze[1]) then 1 else 0 end) +
       (case when (goscie[2] > gospodarze[2]) then 1 else 0 end) +
       (case when (goscie[3] > gospodarze[3]) then 1 else 0 end) +
       (case when (goscie[4] > gospodarze[4]) then 1 else 0 end) +
       (case when (goscie[5] > gospodarze[5]) then 1 else 0 end)) >= 3;

--jezeli chodzi, ze było tylko 3 sety i wszystkie wygrane przez godcie
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze, goscie
from mvp
where imie in ('Anna', 'Alicja', 'Anastazja')
  and array_length(gospodarze, 1) = 3
  and goscie[1] > gospodarze[1]
  and goscie[2] > gospodarze[2]
  and goscie[3] > gospodarze[3];

--probowałem tu dodac dodatkowe kolumny z iloscia wygranych przez godcie oraz gospodarze
SELECT *, (array_length(podzapytanie.gospodarze, 1) - wygrali_goscie) AS wygrali_gospodarze
FROM (SELECT imie, nazwisko, iddruzyny, idmeczu, gospodarze, goscie,
             ((case when (goscie[1] > gospodarze[1]) then 1 else 0 end) +
              (case when (goscie[2] > gospodarze[2]) then 1 else 0 end) +
              (case when (goscie[3] > gospodarze[3]) then 1 else 0 end) +
              (case when (goscie[4] > gospodarze[4]) then 1 else 0 end) +
              (case when (goscie[5] > gospodarze[5]) then 1 else 0 end)) AS wygrali_goscie
      FROM mvp) AS podzapytanie
ORDER BY wygrali_goscie DESC;

--8.4 MVP została zawodniczka drużyny o identyfikatorze
-- chemik, łks lub rysice, grająca na pozycji innej niż atakująca i mecz miał 5 setów
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze, goscie
from mvp
where iddruzyny in ('chemik', 'łks' ,'rysice')
  and not pozycja = 'atakujaca'
  and array_length(gospodarze, 1) = 5;

--8.5 MVP została zawodniczka grająca na pozycji libero,
-- drużyna gospodarzy przegrała pierwszy set, ale wygrała cały mecz 3-2

--nie wiedziałem, ze 5 set jest tylkoi w przypadku, jezeli z pierwszych 4 jest remis
select imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze, goscie
from mvp
where pozycja = 'libero' and
      gospodarze[1] < goscie[1] and
      array_length(gospodarze, 1) = 5 and
      ((case when (gospodarze[2] > goscie[2]) then 1 else 0 end ) +
      (case when (gospodarze[3] > goscie[3]) then 1 else 0 end ) +
      (case when (gospodarze[4] > goscie[4]) then 1 else 0 end ) +
      ((case when (gospodarze[5] > goscie[5]) then 1 else 0 end ))) = 3;

--no troche sie skrociło
SELECT imie, nazwisko, iddruzyny, pozycja, idmeczu, gospodarze, goscie
FROM mvp
WHERE pozycja = 'libero'
  AND gospodarze[1] < goscie[1]
  AND array_length(gospodarze, 1) = 5
  AND gospodarze[5] > goscie[5];