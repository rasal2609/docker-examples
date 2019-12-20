#!/bin/bash

USER=root
PASSWORD=""
SOCKET=/tmp/mysql01.sock
LOGFILE="./lvmbackup.log"
LVMSHARE="/dev/centos/mysql_db01"


export PATH=/opt/mysql/mysql-8.0.11/bin/:$PATH
DATE=`date +'%Y%m%d_%H%M%S'`

# lock MySQL tables
mysql -u$USER -p$PASSWORD -S$SOCKET > $LOGFILE <<EOF
flush tables with read lock;
show master status\G
system lvcreate -L512M -s -n Backup_${DATE} $LVMSHARE
EOF

MOUNT="./Backup_${DATE}";
mkdir $MOUNT
mount -o nouuid /dev/centos/Backup_${DATE} $MOUNT

echo -n > lvm_remove_backup.sh "echo \"remove backup from $DATE\"
umount $MOUNT
rm -rf $MOUNT"
