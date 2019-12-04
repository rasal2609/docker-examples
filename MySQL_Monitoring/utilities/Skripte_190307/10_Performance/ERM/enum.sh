#!/usr/bin/bash

MYSQL="mysql -uroot --socket=/tmp/mysql01.sock"


$MYSQL <<EOF
create database if not exists enum;
use enum;
drop table if exists names;
create table names (first_name char(100), last_name char(100));
insert into enum.names select a.first_name, b.last_name from sakila.actor a, sakila.actor b;
analyze table enum.names;
exit
EOF


echo "alter table names modify last_name enum("
for name in `$MYSQL -N --execute="select distinct last_name from enum.names"`
 do
	echo -e "\"$name\","
 done
echo ")"

$MYSQL --execute="select data_length, index_length from information_schema.tables where table_name='names' and table_schema='enum'"
