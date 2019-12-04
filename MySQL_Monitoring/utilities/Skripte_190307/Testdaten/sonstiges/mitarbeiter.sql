CREATE TABLE mitarbeiter
	(
	mitarbeiternr INT PRIMARY KEY AUTO_INCREMENT,
	mitarbeitername VARCHAR(20),
	abteilungsnr INT,
	gehalt DECIMAL(10,2),
	beruf VARCHAR(20)
	);
