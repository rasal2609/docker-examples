drop database if exists firma;
create database if not exists firma;
use firma;


create table if not exists firma.abteilung (
  abteilungsnr int(2) primary key,
  abteilungsname varchar(20),
  niederlassung varchar(20)) engine=innodb;

create table if not exists firma.kunde(
  kundennr int(2) primary key,
  kundenname varchar(15),
  plz varchar(6),
  ort varchar(16),
  adresse varchar(40),
  telefon varchar(20),
  kreditlimit decimal(9,2)) engine=innodb;

create table if not exists firma.mitarbeiter(
  mitarbeiternr int(4) primary key,
  mitarbeitername varchar(15),
  beruf varchar(22),
  vorgesetzter int(4),
  eintrittsdatum DATE,
  gehalt decimal(9,2)    NOT NULL,
  provision decimal(9,2),
  abteilungsnr int(2))engine=innodb;

CREATE TABLE if not exists firma.projektbelegung(
  projektnr int(4),
  mitarbeiternr int(4),
  aufgabe varchar(35),
  bemerkung varchar(200))engine=innodb;

CREATE TABLE if not exists firma.projekt(
     projektnr int(4) primary key,
     projektname varchar(25)  NOT NULL,
     projektbeginn DATE,
     projektende DATE,
     verantwortlicher int(4),
     kundennr int(9)
    ) engine=innodb;
