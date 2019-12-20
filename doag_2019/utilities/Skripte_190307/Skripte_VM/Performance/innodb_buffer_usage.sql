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
/*******************************************************************/



select 'InnoDB Buffer Size';
select variable_value/1024/1024 "InnoDB Buffer Size (MB)" from information_schema.global_variables where variable_name = 'innodb_buffer_pool_size';

select
(select variable_value "total_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_total') "Total Pages",
(select variable_value "total_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_total') * 16 / 1024  "Buffer Size MB",
(select variable_value "free_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_free') "Free Pages",
(select variable_value "used_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_data') "Used Pages",
(select variable_value "used_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_data') /
(select variable_value "free_pages"
  from information_schema.global_status
    where variable_name = 'innodb_buffer_pool_pages_total') "Buffer Used %"
 ;
