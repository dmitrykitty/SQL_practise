--==================2021-2022====================
--same as before
-- select p.idplaylisty
-- from playlist p
-- where 300 < all (select u.dlugosc
--                  from utwory u
--                           join zawartsoc z using (idplaylisty)
--                  where z.idplaylisty = p.idplaylisty)
--   and 'Pop' = any (select a.gatunek
--                    from albumy a
--                             join utwory u using (idalbumu)
--                             join zawartosc z using (idplaylisty)
--                    where z.idplaylisty = p.idplaylisty);



--==================2022-2023====================



