/********************************************************************
** File: 02_event.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: creates an example event
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

drop event if exists everyminute2;

delimiter $$

create event everyminute2
	on schedule every 1 minute
	starts now()
	ends current_timestamp() + interval 10 minute
	on completion preserve
		do
		begin

		create table if not exists usermon
			(
			id int primary key auto_increment,
			no_users int
			) engine=myisam;

		insert into test.usermon values ( null , 
			( select count(*) from information_schema.processlist ) );
		end;
$$
delimiter ;	
