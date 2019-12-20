#!/bin/bash

MYSQL="/opt/mysql/mysql-5.6.5/bin/mysql --socket=/tmp/mysql3.sock"

for db in 1 2 3 4
	do
	${MYSQL} --execute="drop database if exists repl${db};"
	done
