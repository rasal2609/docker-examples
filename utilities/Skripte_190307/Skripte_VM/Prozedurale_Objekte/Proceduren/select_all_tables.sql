/********************************************************************
** File: select_all_tables.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: procedure that lists all table names of all databases
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

use test;
drop table if exists test.tables;
create table if not exists test.tables as select table_name, table_schema from information_schema.tables;


drop procedure if exists listalltables;
delimiter $$

create procedure listalltables ( in db varchar(20) )
  begin
  declare v_table varchar(40);
  declare v_schema varchar(40);
  declare v_cursor int default 0;
  declare my_tables cursor for select table_name, table_schema
                              from test.tables
                                where table_schema = db;
  declare continue handler for not found set v_cursor = 1;

  open my_tables;

  mytabs:loop
  fetch my_tables into v_table, v_schema;

  if v_cursor = 1 then
  select "no more tables";
  leave mytabs;
  end if;

  set @stmt = CONCAT('select * from ', v_schema, '.', v_table);
  select @stmt;
  prepare s1 from @stmt;
  execute s1;

  end loop mytabs;

  close my_tables;
  end;

$$

delimiter ;
call listalltables('test');
