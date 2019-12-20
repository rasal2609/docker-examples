set sql_log_bin=off;
CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';
INSTALL PLUGIN group_replication SONAME 'group_replication.so';
set sql_log_bin=on;
