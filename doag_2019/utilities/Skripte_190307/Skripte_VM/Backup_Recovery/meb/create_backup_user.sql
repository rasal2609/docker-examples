/********************************************************************
** File: create_backup_user.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: creates a user account for mysql enterprise backup
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   --------    -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

GRANT RELOAD ON *.* TO 'dba'@'localhost' identified by 'dba';
GRANT SELECT, CREATE, INSERT, DROP ON mysql.ibbackup_binlog_marker TO 'dba'@'localhost';
GRANT SELECT, CREATE, INSERT, DROP ON mysql.backup_progress TO 'dba'@'localhost';
GRANT SELECT, DELETE, CREATE, INSERT, DROP ON mysql.backup_history TO 'dba'@'localhost';
GRANT REPLICATION CLIENT ON *.* TO 'dba'@'localhost';
GRANT SUPER ON *.* TO 'dba'@'localhost';
GRANT CREATE TEMPORARY TABLES ON mysql.* TO 'dba'@'localhost';
