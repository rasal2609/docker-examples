#!/bin/bash

DAY=`date +'%a'`

mv /tmp/mysql/*.err /tmp/mysql/`hostname -s`.err.${DAY}
mysql --execute="flush error logs"
