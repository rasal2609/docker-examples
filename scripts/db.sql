CREATE DATABASE appldb;
CREATE USER 'appl'@'%' IDENTIFIED BY 'appl';
GRANT ALL PRIVILEGES ON appldb.* TO 'appl'@'%';
