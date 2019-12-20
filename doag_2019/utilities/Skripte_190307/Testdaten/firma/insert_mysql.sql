use firma;


DELETE FROM projektbelegung;
DELETE FROM projekt;
DELETE FROM mitarbeiter;
DELETE FROM kunde;
DELETE FROM abteilung;

INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 11, 'Vertrieb', 'Nuernberg' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 12, 'Vertrieb', 'Muenchen' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 21, 'Entwicklung', 'Nuernberg' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 22, 'Entwicklung', 'Muenchen' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 31, 'Personal', 'Nuernberg' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 32, 'Personal', 'Muenchen' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 1, 'Vorstand', 'Muenster' );
INSERT INTO abteilung( abteilungsnr, abteilungsname, niederlassung )
  VALUES ( 99, 'Dummy', 'Paderborn' );

INSERT INTO kunde(kundennr, kundenname, plz, ort, adresse, telefon, kreditlimit ) 
  VALUES( 1, 'Meier', '90000', 'Nuernberg', 'Bahnhofstr. 10', '0911/110', 900.00 );
INSERT INTO kunde(kundennr, kundenname, plz, ort, adresse, telefon, kreditlimit ) 
  VALUES( 2, 'Mueller', '89000', 'Muenchen', 'Bahnhofstr. 10', '098/110', 900.00 );
INSERT INTO kunde(kundennr, kundenname, plz, ort, adresse, telefon, kreditlimit ) 
  VALUES( 3, 'Schmidt', '40000', 'Hamburg', 'Reeperbahn. 10', '040/666666', 10.00 );
INSERT INTO kunde(kundennr, kundenname, plz, ort, adresse, telefon, kreditlimit ) 
  VALUES( 4, 'Luky Luke', '39100', 'Paderborn', 'Reeperbahn. 10', '05251/666777', 1050.00 );
INSERT INTO kunde(kundennr, kundenname, plz, ort, adresse, telefon, kreditlimit ) 
  VALUES( 5, 'Berta Brinke', '48291', 'Telgte',   'Zur Schmiede 12', '02504/667', 3058.00 );

INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 1, 'Dr. Klose', NULL, 99000.00, 1,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 11, 'Pumuckl', 1, 33000.00, 12,curdate(),'Projekassistent');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 12, 'Gruber', 1, 68000.00, 11,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 13, 'Joschko', 1, 65000.00, 31,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 14, 'Zeitz', 1, 66500.00, 32,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 15, 'Martin', 1, 70000.00, 21,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 16, 'Stephan', 1, 70000.00, 22,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 111, 'Schnier', 16, 50000.00, 22,curdate(),'Vertriebsbeauftragter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 112, 'Mattia', 12, 50000.00, 21,curdate(),'Projektleiter');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 113, 'Schlamann', 13, 20000.00, 31,curdate(),'Projektassistent');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf) 
  VALUES ( 114, 'Dechant', 14, 19000.00, 22,curdate(),'Schreibkraft');
INSERT INTO mitarbeiter (mitarbeiternr, mitarbeitername, vorgesetzter, gehalt, abteilungsnr, eintrittsdatum, beruf)
  VALUES ( 115, 'Dunkel', 14, 19000.00, 31,curdate(),'Projektleiter');

INSERT INTO projekt (projektnr, projektname, projektbeginn, projektende, verantwortlicher, kundennr)
  VALUES (2000, 'Jahr 2000', curdate(), '2006-12-31', 115, 2 );
INSERT INTO projekt (projektnr, projektname, projektbeginn, projektende, verantwortlicher, kundennr)
  VALUES (1999, 'SQL Kurs', curdate(),  '2006-12-31', 12, 3 );
INSERT INTO projekt (projektnr, projektname, projektbeginn, projektende, verantwortlicher, kundennr)
  VALUES (800, 'SAP Einfuehrung', curdate(),  '2006-12-31', 14, 4 );
INSERT INTO projekt (projektnr, projektname, projektbeginn, projektende, verantwortlicher, kundennr)
  VALUES (900, 'Personal-Beurteilung', curdate(),  '2006-12-31', 13, 5 );

INSERT INTO projektbelegung (projektnr, mitarbeiternr, aufgabe, bemerkung)
  VALUES (900, 13, 'Leitung', 'Verantwortung');
INSERT INTO projektbelegung (projektnr, mitarbeiternr, aufgabe, bemerkung)
  VALUES (900, 14, 'Assistenz', 'fuer alles');
INSERT INTO projektbelegung (projektnr, mitarbeiternr, aufgabe, bemerkung)
  VALUES (1999, 114, 'Assistenz', 'fuer alles');


COMMIT;




