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
begin

end;
$$
    language plpgsql;