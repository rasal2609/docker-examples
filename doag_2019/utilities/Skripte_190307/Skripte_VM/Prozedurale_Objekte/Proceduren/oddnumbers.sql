/********************************************************************
** File: oddnumbers.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: simple example procedure
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/
use sql_ueb;

drop procedure if exists oddnumbers;

delimiter $$

create procedure oddnumbers()
  begin
  declare counter int default 0;

  run: loop

  set counter=counter+1;

  if counter >= 10 then
  leave run;
  end if;

  if mod(counter,2) = 0 then
  select concat(counter, ' ist gerade');
  else
  select concat(counter, ' ist ungerade');
  iterate run;
  end if;

  select 'ende der schleife';

  end loop run;

  end;
$$
