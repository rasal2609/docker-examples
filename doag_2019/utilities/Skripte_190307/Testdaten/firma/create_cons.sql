use firma;

alter table mitarbeiter add constraint fk_abt foreign key (abteilungsnr) references abteilung (abteilungsnr);
alter table mitarbeiter add constraint fk_ma foreign key (vorgesetzter) references mitarbeiter (mitarbeiternr);
alter table projekt add constraint fk_kd foreign key (kundennr) references kunde (kundennr);
alter table projekt add constraint fk_ma2 foreign key (verantwortlicher) references mitarbeiter (mitarbeiternr);
alter table projektbelegung add constraint fk_ma3 foreign key (mitarbeiternr) references mitarbeiter (mitarbeiternr);
alter table projektbelegung add constraint fk_pro foreign key (projektnr) references projekt (projektnr);
