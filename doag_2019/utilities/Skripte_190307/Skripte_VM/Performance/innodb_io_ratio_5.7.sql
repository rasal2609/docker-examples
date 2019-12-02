/********************************************************************
** File: innodb_io_ratio.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: get information about the op pattern (physical / logical)
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

set @logical_reads:=0;
set @physical_reads:=0;


select @physical_reads:=variable_value from global_status where variable_name = 'InnoDB_buffer_pool_reads';
select @logical_reads:=variable_value from global_status where variable_name = 'InnoDB_buffer_pool_read_requests';

select concat('InnoDB buffer hit (in %): ') as Buffer_Hit, round(@physical_reads/@logical_reads*100,2) Percent;
