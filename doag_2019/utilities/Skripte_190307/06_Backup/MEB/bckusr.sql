# backup user
DROP USER 'backup'@'localhost';
CREATE USER 'backup'@'localhost' IDENTIFIED BY 'backup';
GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'backup'@'localhost';
ALTER USER 'backup'@'localhost' identified with mysql_native_password by 'backup';
FLUSH PRIVILEGES;
exit
