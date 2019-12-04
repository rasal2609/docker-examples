/********************************************************************
** File: myisam_buffer_usage.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: information about the myisam buffer usage (size etc.)
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/


select 'MyISAM Buffer Usage';
select sum(variable_value) "Buffer Blocks Total",
  (
  select variable_value from information_schema.global_status where variable_name = 'key_blocks_unused'
  ) "Buffer Blocks Free",
  (
  select variable_value from information_schema.global_status where variable_name = 'key_blocks_unused'
  )
  / sum(variable_value)  "Buffer Blocks Free (%)"
  from information_schema.global_status
    where variable_name in ('key_blocks_used', 'key_blocks_unused');
