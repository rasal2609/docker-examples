DROP USER 'backup'@'localhost';
CREATE USER 'backup'@'localhost' IDENTIFIED WITH mysql_native_password BY 'backup';
GRANT BACKUP_ADMIN, RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'backup'@'localhost';
