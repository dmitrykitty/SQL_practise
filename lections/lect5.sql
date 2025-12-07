set search_path to public, siatkowka;

select *
from druzyny
         natural join siatkarki
         natural join punkty;
-- dolaczaja sie kolumny unikatowe wsrod dwoch tabel pod
-- warunkiem, ze jest 1 lub wiecej atrybut wspolny np. zamowienia.idklienta = klienci.idklienta

select nazwisko, imie, termin, punkty
from siatkarki
         natural join punkty
         natural join mecze
order by termin;


select nazwa, nazwisko, imie, punkty, termin
from druzyny
         natural join siatkarki
         natural join punkty
         natural join mecze
order by termin;


select kompozycje.nazwa, zamowienia.cena, klienci.miasto
from kompozycje
         join zamowienia using (idkompozycji)
    -- naturall join - 2 wspolne atrybuty, wybor tylko jednakowych cen
--using -> 2 klumny cena
         join klienci on klienci.idklienta = zamowienia.idodbiorcy
--nie przeszlo by ani using, ani natruall join bo nie ma odpowiadajacych atrybutow wsp
--join on pozwala polaczyc wg wybranych atrybutow i podaczajac wszystkie kolumny
--z jednej tabeli do istniejacej tabeli
where zamowienia.termin = '2025 - 10 - 27';

select gospodarze, goscie, termin
from mecze;

select d1.nazwa as "Gospodarze", d2.nazwa as "Goscie", termin
from druzyny d1
         join mecze on d1.iddruzyny = gospodarze
         join druzyny d2 on d2.iddruzyny = goscie;


select d1.nazwa, d2.nazwa, s.gospodarze, s.goscie, termin
--alias d1(1) dla druzyny
from druzyny d1
         join mecze on d1.iddruzyny = gospodarze
    --alias d2(2)
    ---> laczenie tabeli d1 z mecze i z d2 (join on - teta zaczenie)
         join druzyny d2 on d2.iddruzyny = goscie
         join statystyki s using (idmeczu);


select imie , nazwisko , idmeczu , punkty
from siatkarki natural left join punkty;
--polaczenie wszystkich siatkarek i wszystkich meczy
--ae rowniez siarkarek ktore nie graly