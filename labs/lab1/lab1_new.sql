set search_path to public, siatkowka;


--5. Korzystając z możliwości filtrowania danych (warunek WHERE), wyszukaj dane o czekoladkach:

--5.1 które są w mlecznej czekoladzie;
select *
from czekoladki
where czekolada = 'mleczna';

--5.2 które są w mlecznej czekoladzie i zawierają orzechy laskowe;
select *
from czekoladki
where orzechy is not null
  and czekolada = 'mleczna';

--5.3 które są w mlecznej lub w gorzkiej czekoladzie (użyj in);
select *
from czekoladki
where czekolada in ('mleczna', 'gorzka');

--5.4 których masa jest większa niż 25 g.
select *
from czekoladki
where masa > 25;

--====================================================

--6.Korzystając z możliwości filtrowania danych, wyszukaj dane o klientach:

--6.1 którzy są z Gdańska, Krakowa lub Warszawy;
select *
from klienci
where miejscowosc in ('Kraków', 'Warszawa', 'Gdańsk');

--lub uzywajac regec jezeli nie wiadomo z jakiej litery miejscowosci
select *
from klienci
where miejscowosc similar to '[Kk]rak[oó]w' or
      miejscowosc similar to '[Ww]arszawa' or
      miejscowosc similar to '[Gg]da[nń]sk';


--lub połaczenie regexem kilka mias naraz
select *
from klienci
where miejscowosc similar to '([Kk]rak[oó]w|[Ww]arszawa|[Gg]da[nń]sk)';

--6.2 którzy nie są z Gdańska;
select *
from klienci
where miejscowosc not similar to '[Gg]da[nń]sk';

--uzywajac ilike to ignore upper case (w poprzednim tez mozna było)
select *
from klienci
where miejscowosc not ilike 'gdańsk';

--6.3 którzy mieszkają (mają siedzibę) przy ulicy Akacjowej (UWAGA: możliwe różne numery, patrz uwaga o LIKE poniżej)
select*
from klienci
where ulica ilike '%akacjowa%';