/********************************************************************
** File: myisam_buffer_ratio.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: performance about the io pattern (physical / logical)
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

select 'MyISAM Buffer Cache Hit';
select
(
select variable_value from performance_schema.global_status where variable_name = 'key_reads'
) "Key Read",
(
select variable_value from performance_schema.global_status where variable_name = 'key_read_requests'
) "Key Read Requests",
1 - (
select variable_value from performance_schema.global_status where variable_name = 'key_reads'
)
/
(
select variable_value from performance_schema.global_status where variable_name = 'key_read_requests'
) "Hit Ratio"
