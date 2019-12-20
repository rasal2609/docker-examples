/********************************************************************
** File: tmp_disk_usage.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: information about the number of created tmp disk tables
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/


select 'TMP Disk Ratio';
select
(select variable_value
  from information_schema.global_status
    where variable_name = 'created_tmp_disk_tables'
) "Created TMP Disks Tables",
(select variable_value
  from information_schema.global_status
    where variable_name = 'created_tmp_tables'
) "Created TMP Tables",
(select variable_value
  from information_schema.global_status
    where variable_name = 'created_tmp_disk_tables'
) /
(select variable_value
  from information_schema.global_status
    where variable_name = 'created_tmp_tables'
) "TMP Disk Ratio (%)"
