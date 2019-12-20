SET SQL_LOG_BIN=0;
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
DROP USER IF EXISTS 'repl'@'localhost';
#
# with 8.0.11 replication has a bug; use root instead of repl user
#
CREATE USER 'repl'@'localhost' IDENTIFIED BY 'repl' REQUIRE SSL;
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'localhost';
FLUSH PRIVILEGES;
SET SQL_LOG_BIN=1;

