/********************************************************************
** File: innodb_buffer_usage.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: get information about the innodb buffer activity
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
** 02   23/09/2016  Jung        MySQL 5.7
/*******************************************************************/



use performance_schema;

set @buffer_page:=0;
set @buffer_size:=0;
set @pages_used:=0;

select @buffer_page:=variable_value from global_variables where variable_name = 'Innodb_page_size';
select @buffer_size:=variable_value from global_variables where variable_name = 'innodb_buffer_pool_size';
select @pages_unused:=variable_value from global_status where variable_name = 'Innodb_buffer_pool_pages_free';

select concat('Buffer size (MB): ') as Size, @buffer_size/1024/1024 MB;
select concat('Buffer free (in %): ') as Free, round((@pages_unused * @buffer_page) / @buffer_size * 100,2) Percent;