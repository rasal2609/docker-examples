#!/bin/bash

MYSQL="/opt/mysql/mysql-5.6.5/bin/mysql --socket=/tmp/mysql3.sock"

for db in 1 2 3 4
	do
	${MYSQL} --execute="create database if not exists repl${db};"
	${MYSQL} --execute="create table if not exists repl${db} (id int primary key auto_increment, val varchar(20)) engine=innodb;" repl${db}
	done

while [ 1 ]
	do
	VAL=`/bin/date`
	for db in 1 2 3 4
		do
		STMT="set local binlog_format='STATEMENT'; use repl${db}; insert into repl${db}.repl${db} values (null, '${VAL}'); commit;"
		${MYSQL} --execute="${STMT}"
		echo "${STMT}"
		done
	done
