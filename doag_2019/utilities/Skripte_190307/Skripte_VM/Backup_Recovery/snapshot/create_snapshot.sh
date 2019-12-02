#!/bin/bash

MYSQL="/opt/mysql/mysql-5.5.24/bin/mysql -uroot"
DATE=`/bin/date +'%Y%m%d_%H%M%S'`

mount -f /tmp/last_snap


echo "lock server"
${MYSQL} <<EOF
flush tables with read lock;
system /usr/sbin/lvcreate -L1024M -s -n data01_${DATE} /dev/VolGroup00/mysqldata01
unlock tables;
EOF

mount /dev/VolGroup00/data01_${DATE} /tmp/last_snap
