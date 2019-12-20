/********************************************************************
** File: 01_cursor.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: example procedure using a cursor based on database firma
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

drop procedure if exists sumgehalt;

delimiter |
create procedure sumgehalt(IN abtnr int, OUT v_summe decimal(9,2))
  begin
    declare v_gehalt, v_provision decimal(9,2);
    declare c_status boolean default true;
    declare my_cursor cursor for
      select gehalt, provision
        from mitarbeiter
          where abteilungsnr = abtnr;
    declare continue handler for sqlstate '02000' set c_status = FALSE;

  open my_cursor;
  set v_summe = 0;

  fetch my_cursor into v_gehalt, v_provision;

  while c_status do

      select v_gehalt, v_provision;
      set v_summe = v_summe + v_gehalt + ifnull(v_provision,0);
      fetch my_cursor into v_gehalt, v_provision;

  end while;

  close my_cursor;
  end |
delimiter ;
