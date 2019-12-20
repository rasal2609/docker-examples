#!/usr/bin/bash

TYPE=incr
USER=root
DATE=`date +'%Y%m%d_%H%M%S'`
BACKUP_SHARE=/backup/MEB/${TYPE}_${DATE}


LAST_FULL=`ls  /backup/MEB/ | grep full | tail -1`
echo "LAST_FULL: $LAST_FULL"

BASE_SHARE=/backup/MEB/${LAST_FULL}

[ -d $BACKUP_SHARE ] || mkdir -p $BACKUP_SHARE

xtrabackup --backup --user=root --target-dir=$BACKUP_SHARE --incremental-basedir=$BASE_SHARE --socket=/tmp/mysql.sock
