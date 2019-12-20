#!/usr/bin/bash

# create backup and compress
mysqldump --user=root --socket=/tmp/mysql01.sock --all-databases --master-data=2 \
| bzip2  > mysqldump.sql.bz2

# encrypt backup
gpg --encrypt --recipient ordix mysqldump.sql.bz2

# pass backup tp owner "ordix"
chown ordix mysqldump.sql.bz2.gpg
