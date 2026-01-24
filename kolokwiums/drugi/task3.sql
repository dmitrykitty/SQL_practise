create schema kolokwium;
set search_path to kolokwium;


--==================2021-2022====================
create table wykonawcy
(
    idwykonawcy int primary key ,
    nazwa varchar(100) not null ,
    kraj varchar(30) not null ,
    data_debiutu date not null ,
    data_zakonczenia date
);

create table albumy
(
    idalbumu int primary key ,
    idwykonawcy int not null references wykonawcy(idwykonawcy),
    nazwa varchar(50) not null ,
    gatunek varchar(20) not null,
    data_wydania date not null
);

alter table albumy
add constraint gatunek_check check ( gatunek in ('Rock', 'Pop', 'Metal'));

alter table klienci
add constraint login_min_length check ( length(login) >= 5);



--==================2022-2023====================
--same as before


--==================2023-2024====================
alter table albumy
drop column gatunek;

alter table albumy
add column pozycja int not null default 0;

alter table albumy
add constraint min_nazwa check(length(nazwa) >= 5);