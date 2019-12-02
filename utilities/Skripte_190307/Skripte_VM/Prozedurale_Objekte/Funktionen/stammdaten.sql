/********************************************************************
** File: stammdaten.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: creates an example procedure based on the database firma
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

drop function if exists stammdaten;

delimiter |
create function stammdaten( v_manr int )
  returns varchar(200)
  reads sql data
    begin

    declare v_name, v_abt, v_beruf varchar(50);
    declare stammdaten varchar(200);

    select mitarbeitername, abteilungsname, beruf into v_name, v_abt, v_beruf
      from mitarbeiter m, abteilung a
        where m.abteilungsnr = a.abteilungsnr
        and mitarbeiternr = v_manr;

    set stammdaten = concat('Name: ', v_name, ' - Abeilung: ', v_abt, ' - Beruf: ', v_beruf);
    return stammdaten;

    end |
delimiter ;
