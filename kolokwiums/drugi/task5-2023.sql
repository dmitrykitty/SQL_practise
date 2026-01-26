-- 5. (5p.) Napisz funkcję podziel_album, która przenosi nadwyżkę utworów do nowej kopii albumu. Funkcja
-- przyjmuje dwa argumenty: idalbumu_od (int) oraz idalbumu_do (int). Funkcja zwraca boolean.
-- Jeżeli w podanym albumie o id idalbumu_od jest 10 lub mniej utworów to funkcja nie robi nic i zwraca
-- false. Jeżeli jest powyżej 10 utworów, to funkcja tworzy nowy album o id idalbumu_do, o tych samych
-- parametrach co pierwotny album, ale z doklejonym dopiskiem ’ (vol 2)’ w nazwie, a następnie przenosi do
-- niego nadwyżkę utworów z oryginalnego albumu. W tym przypadku funkcja zwraca true.
-- Nie ma znaczenia, które z utworów zostaną wyznaczone do przeniesienia - najważniejsze, aby w pierwotnym
-- albumie zostało ich dokładnie 10. Zakładamy również, że album docelowy jeszcze nie istnieje w bazie.

create or replace function podziel_album(p_idalbumu_od int, p_idalbumu_do int)
    returns boolean
as
$$
declare
    liczba_utworow int;
    roznica        int;
    row            record;
begin
    perform 1 from albumy where p_idalbumu_od = albumy.idalbumu;

    if not FOUND then
        raise exception 'album with id % does not exist', p_idalbumu_od;
    end if;

    liczba_utworow := (select count(idutworu)
                       from utwory
                       where idalbumu = p_idalbumu_od);


    if (liczba_utworow) <= 10 then
        return false;
    end if;

    insert into albumy (idalbumu, idwykonawcy, nazwa, gatunek, data_wydania)
    select p_idalbumu_do, a.idwykonawcy, concat(a.nazwa, 'vol2'), a.gatunek, a.data_wydania
    from albumy a
    where a.idalbumu = p_idalbumu_od;

    roznica := liczba_utworow - 10;
    update utwory
    set idalbumu = p_idalbumu_do
    where idutworu in (select idutworu
                       from utwory
                       where idalbumu = p_idalbumu_od
                       limit roznica);
    return true;
end;
$$ language plpgsql;

-- 4. (5p.) Korzystając z operatorów all oraz any (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich wykonawców, dla których wszystkie albumy (których są autorami) należą do gatunku ’pop’ oraz co
-- najmniej jeden z ich został wydany przed rokiem 2024.

select idwykonawcy
from wykonawcy w
where 'pop' = all (select gatunek
                   from albumy
                   where idwykonawcy = w.idwykonawcy)
  and 2024 > any (select date_part('year', data_wydania)
                  from albumy
                  where idwykonawcy = w.idwykonawcy)


select idwykonawcy
from wykonawcy
where idwykonawcy != all (select idwykonawcy
                          from albumy
                          where gatunek != 'pop')
  and idwykonawcy = any (select idwykonawcy
                         from albumy
                         where date_part('year', data_wydania) < 2024);