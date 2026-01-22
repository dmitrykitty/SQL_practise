CREATE TYPE "uzytkownik_rola" AS ENUM (
  'Kuchnia',
  'Manager',
  'Kelner'
);

CREATE TABLE "Dane_Pracownika" (
  "id_pracownika" INT PRIMARY KEY NOT NULL,
  "imię" VARCHAR(255) NOT NULL,
  "nazwisko" VARCHAR(255) NOT NULL,
  "numer" VARCHAR(255) NOT NULL
);

CREATE TABLE "Pracownicy" (
  "id" SERIAL PRIMARY KEY,
  "login" VARCHAR(50) UNIQUE NOT NULL,
  "haslo" VARCHAR(255) NOT NULL,
  "rola" uzytkownik_rola NOT NULL
);

CREATE TABLE "Menu" (
  "id" SERIAL PRIMARY KEY,
  "nazwa" VARCHAR(100) NOT NULL,
  "data_utworzenia" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Receptury" (
  "id" SERIAL PRIMARY KEY,
  "opis_przygotowania" TEXT NOT NULL
);

CREATE TABLE "Receptura_Skladniki" (
  "id_receptury" INT,
  "id_skladnika" INT,
  "nazwa" VARCHAR(100) NOT NULL,
  "waga" DECIMAL(10,3) NOT NULL,
  PRIMARY KEY ("id_receptury", "id_skladnika")
);

CREATE TABLE "Potrawy" (
  "id" SERIAL PRIMARY KEY,
  "nazwa" VARCHAR(200) NOT NULL,
  "cena" DECIMAL(10,2) NOT NULL,
  "id_menu" INT,
  "id_receptury" INT
);

CREATE TABLE "Stoliki" (
  "id" SERIAL PRIMARY KEY,
  "numer_stolika" INT UNIQUE NOT NULL,
  "liczba_miejsc" INT NOT NULL,
  "status" VARCHAR(20) NOT NULL,
  "id_kelnera" INT NOT NULL
);

CREATE TABLE "Dane_Klienta" (
  "id" SERIAL PRIMARY KEY,
  "imie" VARCHAR(100),
  "nazwisko" VARCHAR(100),
  "numer_telefonu" VARCHAR(20)
);

CREATE TABLE "Rezerwacje" (
  "id" SERIAL PRIMARY KEY,
  "data_rezerwacji" DATE NOT NULL,
  "godzina_rezerwacji" TIME NOT NULL,
  "liczba_osob" INT NOT NULL,
  "id_stolika" INT,
  "id_klienta" INT,
  "status" VARCHAR(20) DEFAULT 'Aktywna'
);

CREATE TABLE "Zamowienia" (
  "id" SERIAL PRIMARY KEY,
  "data" DATE DEFAULT (CURRENT_DATE),
  "czas_rozpoczecia" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "status" VARCHAR(30) NOT NULL,
  "id_stolika" INT
);

CREATE TABLE "Pozycje_Zamowienia" (
  "id" SERIAL PRIMARY KEY,
  "id_zamowienia" INT,
  "id_potrawy" INT,
  "ilosc" INT NOT NULL CHECK (ilosc > 0),
  "uwagi" TEXT,
  "status" VARCHAR(30)
);

CREATE TABLE "Rachunki" (
  "id" SERIAL PRIMARY KEY,
  "id_zamowienia" INT UNIQUE NOT NULL,
  "suma" DECIMAL(10,2) NOT NULL,
  "data_wystawienia" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "Platnosci" (
  "id" SERIAL PRIMARY KEY,
  "id_rachunku" INT NOT NULL,
  "suma" DECIMAL(10,2) NOT NULL,
  "typ_platnosci" VARCHAR(30) NOT NULL,
  "status_platnosci"  VARCHAR(30) NOT NULL
);

CREATE TABLE "Dokumenty_Sprzedazy" (
  "id" SERIAL PRIMARY KEY,
  "id_platnosci" INT UNIQUE NOT NULL,
  "numer_dokumentu" VARCHAR(50) UNIQUE NOT NULL,
  "data_wystawienia" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "kwota_total" DECIMAL(10,2) NOT NULL
);

CREATE TABLE "Faktury" (
  "id_dokumentu" INT PRIMARY KEY,
  "nip" VARCHAR(15) NOT NULL,
  "dane_nabywcy" TEXT NOT NULL,
  "termin_platnosci" DATE
);

CREATE TABLE "Paragony" (
  "id_dokumentu" INT PRIMARY KEY,
  "numer_fiskalny_kasy" VARCHAR(50)
);

CREATE TABLE "Raporty" (
  "id" SERIAL PRIMARY KEY,
  "id_platnosci" INT,
  "id_zamowienia" INT,
  "typ_raportu" VARCHAR(50),
  "data_wygenerowania" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "wynik_json" JSONB
);

ALTER TABLE "Receptura_Skladniki" ADD FOREIGN KEY ("id_receptury") REFERENCES "Receptury" ("id") ON DELETE CASCADE;

ALTER TABLE "Potrawy" ADD FOREIGN KEY ("id_menu") REFERENCES "Menu" ("id");

ALTER TABLE "Potrawy" ADD FOREIGN KEY ("id_receptury") REFERENCES "Receptury" ("id");

ALTER TABLE "Platnosci" ADD FOREIGN KEY ("id") REFERENCES "Raporty" ("id_platnosci");

ALTER TABLE "Zamowienia" ADD FOREIGN KEY ("id") REFERENCES "Raporty" ("id_zamowienia");

ALTER TABLE "Rezerwacje" ADD FOREIGN KEY ("id_stolika") REFERENCES "Stoliki" ("id");

ALTER TABLE "Rezerwacje" ADD FOREIGN KEY ("id_klienta") REFERENCES "Dane_Klienta" ("id");

ALTER TABLE "Zamowienia" ADD FOREIGN KEY ("id_stolika") REFERENCES "Stoliki" ("id");

ALTER TABLE "Pozycje_Zamowienia" ADD FOREIGN KEY ("id_zamowienia") REFERENCES "Zamowienia" ("id") ON DELETE CASCADE;

ALTER TABLE "Pozycje_Zamowienia" ADD FOREIGN KEY ("id_potrawy") REFERENCES "Potrawy" ("id");

ALTER TABLE "Rachunki" ADD FOREIGN KEY ("id_zamowienia") REFERENCES "Zamowienia" ("id");

ALTER TABLE "Platnosci" ADD FOREIGN KEY ("id_rachunku") REFERENCES "Rachunki" ("id");

ALTER TABLE "Dokumenty_Sprzedazy" ADD FOREIGN KEY ("id_platnosci") REFERENCES "Platnosci" ("id");

ALTER TABLE "Faktury" ADD FOREIGN KEY ("id_dokumentu") REFERENCES "Dokumenty_Sprzedazy" ("id");

ALTER TABLE "Paragony" ADD FOREIGN KEY ("id_dokumentu") REFERENCES "Dokumenty_Sprzedazy" ("id");

ALTER TABLE "Stoliki" ADD FOREIGN KEY ("id_kelnera") REFERENCES "Pracownicy" ("id");

ALTER TABLE "Dane_Pracownika" ADD FOREIGN KEY ("id_pracownika") REFERENCES "Pracownicy" ("id");

ALTER TABLE "Platnosci" ADD FOREIGN KEY ("typ_platnosci") REFERENCES "Platnosci" ("id");

ALTER TABLE "Receptura_Skladniki" ADD FOREIGN KEY ("id_skladnika") REFERENCES "Receptura_Skladniki" ("id_receptury");

ALTER TABLE "Rachunki" ADD FOREIGN KEY ("id_zamowienia") REFERENCES "Rachunki" ("id");
