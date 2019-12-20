/********************************************************************
** File: 02_cursor.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: example procedure using a cursor based on database mysql
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

use mysql;
drop procedure if exists mysqluser;


delimiter $$

create procedure mysqluser()
  begin
  declare v_user varchar(40);
  declare v_host varchar(40);

  declare c_stop boolean default 0;

  declare c_user cursor for
      select user, host
        from mysql.user;

  declare continue handler for not found set c_stop=1;

  open c_user;

  userlist: loop
    fetch c_user into v_user, v_host;

    if c_stop=1 then
      leave userlist;
    end if;

  select v_user, v_host;
  end loop userlist;

  close c_user;

end;
$$
