CREATE DATABASE company_repository;

CREATE TABLE company_storage.company_2
(
    id   INT PRIMARY KEY,
    name VARCHAR(128) UNIQUE,
    date DATE NOT NULL CHECK (date > '1995-01-01' AND DATE < '2020-01-01')
    --MOZNA TEZ W TAKI SPOSOB UNIQUE(name, date)
);

DROP TABLE company_2;

INSERT INTO company_2(id, name, date)
VALUES (1, 'Google', '2001-01-01'),
       (2, 'Apple', '2002-10-29'),
       (3, 'Facebook', '1998-10-05');

CREATE TABLE employee
(
    id         SERIAL PRIMARY KEY, --TYP SERIAL - AUTOMATYCZNA INKREMENTACJA
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    salary     INT
);

DROP TABLE employee;

INSERT INTO employee (first_name, last_name, salary) --TERAZ ID TWORZONE AUTOMATYCZNIE OD 1
VALUES ('Ivan', 'Petrov', 2000),
       ('Ivan', 'Nikitin', 750),
       ('Kristina', 'Mironenko', 5000);