#!/bin/bash

/usr/sbin/tcpdump -i lo port 3306 -s 65535 -x -n -q -tttt > /tmp/tcp.dump & 

echo "create"
mysql --execute="create table if not exists test.x ( a int, b varchar(10) ) engine=innodb;"
echo "insert"
mysql --execute="insert into test.x values ( 1, 'abc');"
echo "select"
mysql --execute="select * from test.x;"
echo "drop"
mysql --execute="drop table if exists test.x;"

jobs
kill %1

/home/mysql/percona/percona-toolkit-2.1.2/bin/pt-query-digest --type=tcpdump /tmp/tcp.dump
