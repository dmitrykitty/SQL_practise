-- 5. (5p.) Napisz funkcję o nazwie wybierz_najciezszy_posilek, która wybierze posiłek o najwyższej gramaturze
-- (doda wiersz do tabeli wybory) dla wybranego zamówienia, daty dostawy oraz pory dnia. Funkcja przyjmuje 3 argumenty:
-- id_zamowienia (int), data_dostawy (date), pora_dnia (varchar).
-- Możesz przyjąć, że istnieje tylko jeden posiłek spełniający kryteria. Jeżeli wybrano już wcześniej posiłek
-- to funkcja aktualizuje id dania w istniejącym rekordzie. Funkcja zwraca id wybranego posiłku (int).


create or replace function wybierz_najciezszy_posilek(p_id_zamowienia int, p_data_dostawy date, p_pora_dnia varchar)
    returns int as
$$
declare
    id_najciezszego_dania int;
begin
    select dn.id_dania
    into id_najciezszego_dania
    from dania dn
             join dostepnosc dost using (id_dania)
             join zamowienia zm using (id_diety)
    where dost.data_dostawy = p_data_dostawy
      and dost.pora_dnia = p_pora_dnia
      and zm.id_zamowienia = p_id_zamowienia
    order by dn.gramatura desc
    limit 1;


    if not exists(select 1
                  from wybory
                  where data_dostawy = p_data_dostawy
                    and id_zamowienia = p_id_zamowienia) then
        insert into wybory
        values (p_id_zamowienia, id_najciezszego_dania, p_data_dostawy);
    else
        update wybory
        set id_dania=id_najciezszego_dania
        where id_zamowienia = p_id_zamowienia
          and data_dostawy = p_data_dostawy;

    end if;

    return id_najciezszego_dania;
end;

$$ language plpgsql;


-- 4. (5p.) Korzystając z operatorów any oraz all (obu) napisz zapytanie SQL pobierające z bazy ID wszystkich
-- dań, które wybrano co najmniej raz w roku 2023, a które jednocześnie nigdy nie były dostępne na kolację.
-- Nie używaj złączeń JOIN
select id_dania
from dania
where id_dania = any (select id_dania
                      from dostepnosc
                      where pora_dnia = 'kolacja')
  and id_dania != all (select id_dania
                       from wybory
                       where id_zamowienia in (select id_zamowienia
                                               from zamowienia
                                               where date_part('year', data_zlozenia) = 2023));


