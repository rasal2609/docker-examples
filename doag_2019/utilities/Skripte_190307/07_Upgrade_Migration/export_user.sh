#!/usr/bin/bash

SQL="select concat('\'', user, '\'', '@', '\'', host, '\'') as account from mysql.user";

mkdir accounts

for user in `mysql -s -N --execute="$SQL"`
	do
	file=`echo $user | sed "s/'//g"`
	mysql -s -N --execute="show grants for $user" > accounts/${file}.sql
	echo $file
	done

