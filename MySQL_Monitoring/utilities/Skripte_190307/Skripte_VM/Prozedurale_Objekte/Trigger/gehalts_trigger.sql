/********************************************************************
** File: gehalts_trigger.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: an audit like trigger on table mitarbeiter database firma
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

use firma;

drop trigger if exists check_gehalt;
drop table if exists audit;

create table audit
	(
	nr int primary key auto_increment,
	altes_gehalt decimal(9,2),	
	neues_gehalt decimal(9,2),	
	bearbeiter varchar(20)
	) engine=myisam;

delimiter |
create trigger check_gehalt
 before update on firma.mitarbeiter
for each row
begin
 if new.gehalt <> old.gehalt then
  insert into firma.audit (altes_gehalt, neues_gehalt, bearbeiter)
              values (old.gehalt, new.gehalt, user());
 end if;
end
|
delimiter ;
