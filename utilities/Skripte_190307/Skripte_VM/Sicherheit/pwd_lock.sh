#!/bin/bash

mysql -s -N --user=root --database=mysql --execute=" select concat('ALTER USER ''', user, '''@''', host, ''' PASSWORD EXPIRE;') from mysql.user where password = '' and user != 'root';"
mysql -s -N --user=root --database=mysql < lock.sql
rm lock.sql
