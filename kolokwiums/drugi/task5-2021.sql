-- 5. (5p.) Napisz funkcję o nazwie uzupelnij_playliste, która przyjmuje trzy argumenty: idplaylisty_od (int),
-- idplaylisty_do (int), polub (boolean). Funkcja skopiuje z playlisty idplaylisty_od do playlisty idplaylisty_do
-- utwory, które nie występują na tej drugiej. Jeżeli parametr polub jest równy TRUE to dla skopiowanych
-- utworów funkcja doda oceny pozytywne (lubi = TRUE), wystawione przez właściciela drugiej playlisty, ale
-- tylko jeśli jeszcze nie mają od niego ocen. Funkcja zwraca tabelę zawierającą wszystkie utwory (wiersze
-- z tabeli utwory) znajdujące się na playliście idplaylisty_do po operacji kopiowania.

create or replace function uzupelnij_playliste(idplaylisty_od int, idplaylisty_do int, polub boolean)
    returns table
            (
                idutworu int,
                idalbumu int,
                nazwa    varchar(100),
                dlugosc  int
            )
as
$$
declare
    id_owner int;
    row      record;
begin
    select idklienta
    into id_owner
    from playlisty
    where idplaylisty = idplaylisty_od;

    for row in (select z_od.idutworu
                from zawartosc z_od
                where idplaylisty = idplaylisty_od
                  and idutworu not in (select idutworu
                                       from zawartosc
                                       where idplaylisty = idplaylisty_do))
        loop
            insert into zawartosc
            values (idplaylisty_do, row.idutworu);

            if polub = true and not exists(select 1
                                           from oceny
                                           where idutworu = row.idutworu
                                             and idklienta = id_owner) then
                insert into oceny(idutworu, idklienta, lubi)
                values (row.idutworu, id_owner, true);

            end if;
        end loop;

    return query
        select utwory.*
        from zawartosc z
                 join utwory using (idutworu)
        where z.idplaylisty = idplaylisty_do;
end;
$$
    language plpgsql;