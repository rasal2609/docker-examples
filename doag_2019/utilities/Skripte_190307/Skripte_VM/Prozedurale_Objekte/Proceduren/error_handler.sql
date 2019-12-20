/********************************************************************
** File: error_handler.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: example procedure demonstrating error handle routines
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

drop procedure if exists fehler;

delimiter |
create procedure fehler()
    begin
      declare continue handler for sqlstate '42S22'
          select 'houston we got a col problem';
      declare exit handler for sqlstate '42S02'
          select 'houston we got a tab problem';

     select nocol from mysql.user;
     select 'weiter';
     select nocol from notable;
     select 'hier geht es nicht weiter';
    end |
delimiter ;
