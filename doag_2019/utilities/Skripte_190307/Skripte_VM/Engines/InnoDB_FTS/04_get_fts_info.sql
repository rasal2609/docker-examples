/********************************************************************
** File: 04_get_fts_info.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: get information about existing fts indices
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

use innodb_fts;

select table_id, hex(table_id) as "HexVal" from information_schema.INNODB_SYS_TABLESTATS where name = 'innodb_fts/quotes';

# get sys tables of table
select table_id, name, space from information_schema.INNODB_SYS_TABLES where name like '%/FTS_%15_%';
SELECT index_id, table_id, name FROM INFORMATION_SCHEMA.INNODB_SYS_INDEXES WHERE table_id=15;

