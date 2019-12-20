#!/usr/bin/bash

TYPE=full
USER=root
DATE=`date +'%Y%m%d_%H%M%S'`
BACKUP_SHARE=/backup/MEB/${TYPE}_${DATE}

[ -d $BACKUP_SHARE ] || mkdir -p $BACKUP_SHARE


xtrabackup --backup --user=root --target-dir=$BACKUP_SHARE --socket=/tmp/mysql.sock
