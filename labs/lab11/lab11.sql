--How to write your own functions

--NON-QUERY RETURN
-- create or replace function fn_name([params])
--     returns [value] --typ zwracany
-- as
-- [optional declare] declare 'alias_name' alias for $[number_of_param]
-- $$
-- begin
--
-- end;
-- $$
-- language plpgsql;

--=================================================================

--QUERY-RETURN
-- create or replace function fn_name([params])
--     returns table
--     (
--     field_name1 type1,
--     field_name2 type2,
--     ...
--     )
-- as
-- [optional declare] declare 'alias_name' alias for $[number_of_param]
-- $$
-- begin
--     RETURN QUERY
--     -- NOTE: table alias is mandatory or use full table name
--     select table_alias.field1, table_alias.filed2 ...
--     from table table_alias
--     ...
-- end;
-- $$
-- language plpgsql;

----=================================================================
--TO SAVE VALUE FROM SELECT TO VARIABLE
--declare result type;
--begin
--      select smth into result
--      from ...
--end;
--=================================================================

--if<condition> then
--    <statement>
--elsif <condition> then
--    <statement>
--else
--    <statement>
--end if;

--=================================================================

--loop
--  exit when <statement>
--end loop;

--=================================================================

-- while <condition>
-- loop
--     <statement>
-- end loop;

--=================================================================

-- for i in 1..10
-- loop
--     <statement>
-- end loop;
--
-- for i in reverse 10..2 by 2
-- loop
--    <statement>
-- end loop;

--=================================================================
-- for val[previosly declared] in select
-- loop
--      <statement>
-- end looop;

----=================================================================
-- foreach val[previosly declared] in array num_array
-- loop
--      <statement>
-- end loop;

create or replace function fn_mid(varchar, int, int)
    returns varchar --typ zwracany
as
$$
begin
    return substr($1, $2, $3); --$1 - first param, $2 - second and ...
end;
$$
    language plpgsql;


select fn_mid('postgresql', 5, 4);

--=================================================================
create or replace function fn_mid1(varchar, int, int)
    returns varchar --typ zwracany
as
$$
declare
    word alias for $1; --dodawanie aliasow dla funkcji
    start alias for $2;
    count alias for $3;
begin
    return substr(word, start, count);
end;
$$
    language plpgsql;


select fn_mid1('postgresql', 5, 4);

--=================================================================
create or replace function fn_mid2(buffer varchar, start int, count int) --mozna odrazu przekazac dane z imieniem
    returns varchar --typ zwracany
as
$$
begin
    return substr(buffer, start, count);
end;
$$
    language plpgsql;

select fn_mid2('postgresql', 5, 4);


--=================================================================
create or replace function fn_make_full_name(first_name varchar, last_name varchar)
    returns varchar
as
$$
begin
    if first_name is null and last_name is null then
        return null;
    elsif first_name is null or last_name is null then
        if first_name is null then
            return last_name;
        else
            return first_name;
        end if;
    else
        return first_name || ' ' || last_name;
    end if;
end;
$$
    language plpgsql;

select fn_make_full_name(null, 'Nikitina');
select fn_make_full_name('Kristina', 'Nikitina');

--=================================================================
create or replace function fn_mean(num_array numeric[])
    returns numeric(6, 2)
as
$$
declare
    total numeric := 0;
    val   numeric;
    count int     := 0;
begin
    foreach val in array num_array
        loop
            total = total + val;
            count = count + 1;
        end loop;
    return round(total / count, 2);
end;
$$
    language plpgsql;


select fn_mean(ARRAY [2, 3, 5]);


set search_path to public, siatkowka;

create or replace function fn_punkty_zdobyte(druzyna varchar(10), mecz int)
    returns integer
as
$$
declare
    id_druzyny   varchar(10);
    suma_punktow int := 0;
    punkty       int[];
    val          int;
begin
    select gospodarze
    into id_druzyny
    from mecze
    where idmeczu = mecz;

    if druzyna = id_druzyny then
        select gospodarze
        into punkty
        from statystyki
        where idmeczu = mecz;
    else
        select goscie
        into punkty
        from statystyki
        where idmeczu = mecz;
    end if;

    foreach val in array punkty
        loop
            suma_punktow := suma_punktow + val;
        end loop;
    return suma_punktow;
end;
$$
    language plpgsql;


select fn_punkty_zdobyte('radomka', 10);


--ZADANIE 1
--1.1 Napisz funkcję masaPudelka wyznaczającą masę pudełka jako sumę masy czekoladek w nim zawartych.
-- Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na prostej instrukcji select.
create or replace function fn_masa_pudelka(idpud pudelka.idpudelka%type)
    returns int
as
$$
declare
    result int;
begin
    perform 1 from pudelka where idpudelka = idpud;

    if not FOUND then
        raise exception 'Błędnę id pudełka: %', idpud;
    end if;

    select coalesce(sum(cz.masa * z.sztuk), 0)
    into result
    from zawartosc z
             join czekoladki cz using (idczekoladki)
    where z.idpudelka = idpud;

    return result;
end;
$$
    language plpgsql;

select fn_masa_pudelka('fudr');


--ZADANIE 2
--2.1 Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje ze sprzedaży jednego pudełka czekoladek, zakładając,
-- że zysk ten jest różnicą między ceną pudełka, a kosztem wytworzenia zawartych w nim czekoladek i kosztem opakowania
-- (0,90 zł dla każdego pudełka). Funkcja jako argument przyjmuje identyfikator pudełka.
-- Przetestuj działanie funkcji na prostej instrukcji select.

create or replace function fn_zysk(idpud pudelka.idpudelka%type)
    returns numeric(7, 2)
as
$$
declare
    result numeric(7, 2);
begin
    perform 1 from pudelka where idpudelka = idpud;
    if not FOUND then
        raise exception 'Bledne id pudelka: %', idpud;
    end if;

    select cena into result from pudelka where idpudelka = idpud;

    return result - 0.90 - coalesce((select sum(cz.koszt * z.sztuk)
                                     from zawartosc z
                                              join czekoladki cz using (idczekoladki)
                                     where idpudelka = idpud), 0);

end;
$$
    language plpgsql;

select fn_zysk('bitt');


--ZADANIE 3
-- ★ Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający nowe zamówienie.
-- Funkcja jako argument przyjmuje identyfikator klienta. Rabat wyliczany jest na podstawie wcześniej złożonych
-- zamówień w sposób następujący:
-- 4 % jeśli wartość zamówień jest z przedziału 101-200 zł;
-- 7 % jeśli wartość zamówień jest z przedziału 201-400 zł;
-- 8 % jeśli wartość zamówień jest większa od 400 zł.


create or replace function fn_rabat(idk klienci.idklienta%type)
    returns numeric(7, 2)
as
$$
declare
    suma_zamowien numeric(7, 2);
    znizka        numeric(7, 2) := 0;
begin
    perform 1 from klienci where idklienta = idk;
    if not FOUND then
        raise exception 'Bad id: %', idk;
    end if;

    select coalesce(sum(a.sztuk * p.cena), 0)
    into suma_zamowien
    from zamowienia z
             join artykuly a using (idzamowienia)
             join pudelka p using (idpudelka)
    where idklienta = idk;


    if suma_zamowien between 101 and 200 then
        znizka := suma_zamowien * 0.04;
    elsif suma_zamowien between 201 and 400 then
        znizka := suma_zamowien * 0.07;
    elseif suma_zamowien > 400 then
        znizka := suma_zamowien * 0.08;
    end if;

--alternatywa
--     znizka :=
--             CASE
--                 WHEN suma_zamowien > 400 THEN suma_zamowien * 0.08
--                 WHEN suma_zamowien >= 201 THEN suma_zamowien * 0.07
--                 WHEN suma_zamowien >= 101 THEN suma_zamowien * 0.04
--                 ELSE 0
--             END;

    return znizka;

end;
$$
    language plpgsql;


select idklienta, nazwa, fn_rabat(idklienta)
from klienci;