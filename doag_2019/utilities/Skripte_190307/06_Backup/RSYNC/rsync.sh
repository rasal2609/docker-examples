#!/bin/bash

USER=root
PASSWORD=""
SOCKET=/tmp/mysql.sock
LOGFILE="./rsyncbackup.log"
MYSQL_SHARE="/mysql/db01"
BACKUP_SHARE="/backup/rsync"


export PATH=/opt/mysql/mysql-8.0.11/bin/:$PATH
DATE=`date +'%Y%m%d_%H%M%S'`

[ -d $BACKUP_SHARE ] || mkdir -p $BACKUP_SHARE
# lock MySQL tables
mysql -u$USER -p$PASSWORD -S$SOCKET > $LOGFILE <<EOF
set global innodb_max_dirty_pages_pct = 0;
select sleep(5);
flush logs;
flush tables with read lock;
show master status\G
system rsync -Sa --progress --verbose $MYSQL_SHARE $BACKUP_SHARE
EOF

