#!/bin/ksh
# set -x 
#
# Author:	Matthias Jung / ORDIX AG
# Description:	MySQL Enterprise Backup Wrapper
# Date:		Mar. 2012
# Version:	1.0 (beta)
#
### Variables ###########################################
MYSQLBIN=/opt/mysql/mysql-5.5.24/bin			#
BASEDIR=/home/mysql/backup/meb				#
LOGDIR=${BASEDIR}/log					#
MEBPATH=/opt/mysql/meb-3.5.2				#
MYCNF=/etc/my.cnf					# path to meb conf file (possibly /etc/my.cnf ?)
BCKPTH=/home/mysql/backup/backups			#
BCKUSER=dump						#
BCKPWD=dump						#
RETENTION=1						# backup retention in days
REDUNDANCY=3						# number of full backups to keep (addtional to RETENTION)
MAXLOGSIZE=2						# size in MB
LOGAGE=1						# max age of logfiles before they are purged
DATE=`/bin/date +'%Y%m%d%H%M%S'`			#	
HOSTNAME=`/bin/hostname`				#
### Variables ###########################################

### usage function
usage()
	{
	clear
	echo -e "#####################################"
	echo -e "ORDIX MySQL Enterprise Backup Wrapper";
	echo -e "$0 -h"
	echo -e "$0 -f => full backup"
	echo -e "$0 -i => incremental backup"
	echo -e "#####################################"
	}
while getopts "fih" arg
do
	case $arg in
	    f)
	    	MODE="full"
		;;
	    i)
	    	MODE="incr"
		;;
	    h|*)
	    	usage
		exit 1
		;;
	esac
done

### functions
WARNINGS=0
ERRORS=0

logger()
	{
	# two log files are written
	#	- cummulative logfile up to X MB
	#	- backup specific log
	# possible error level (1 => Info; 2 => Warning; 3 => Error)

	MSG=${1}
	LVL=${2}

	if [ ${LVL} -eq 1 ]; then
		LEVEL=Info
	elif [ ${LVL} -eq 2 ]; then
		LEVEL=Warning
		WARNINGS=`expr ${WARNINGS} + 1`
	else
		LEVEL=Error
		ERRORS=`expr ${ERRORS} + 1`
	fi

	echo -e "${DATE} - ${LEVEL} - ${MSG}" >> ${LOGDIR}/${HOSTNAME}.blog 
	echo -e "${DATE} - ${LEVEL} - ${MSG}" >> ${LOGDIR}/${HOSTNAME}.${DATE} 

	if [ ${LVL} -eq 3 ]; then
		tidyup
		exit
	fi
	}

backup()
	{
	if [ \! ${MODE} ]; then
		logger "no backup mode defined" 3
	fi

	logger "starting backup" 1	

	if [ ${MODE} == "full" ]; then
		${MEBPATH}/bin/mysqlbackup --user=${BCKUSER} --password=${BCKPWD} --ibbackup=${MEBPATH}/bin/ibbackup ${MYCNF} ${BCKPTH} >> /tmp/meb.$$ 2>&1
		logger "backing up in full mode" 1
	elif [ ${MODE} == "incr" ]; then
		logger "backing up in incremental mode" 1
		LSN=""
		readrepos full
		${MEBPATH}/bin/mysqlbackup --user=${BCKUSER} --password=${BCKPWD} --ibbackup=${MEBPATH}/bin/ibbackup \
		--incremental --lsn ${LSN} ${MYCNF} ${BCKPTH} >> /tmp/meb.$$ 2>&1
	else
		logger "xxx" 1
	fi
	logger "ending backup" 1

	# extracting backup infos for repository
	BCKDST=`/bin/cat /tmp/meb.$$ | /bin/grep "mysqlbackup: Backup created in directory" | /bin/awk -F' ' '{print $NF}'`
	BINLOGFILE=`/bin/cat /tmp/meb.$$ | /bin/grep "mysqlbackup: MySQL binlog position: filename" | /bin/awk -F' ' '{print $(NF-2)}' | /bin/sed '$s/.$//`
	BINLOGPOS=`/bin/cat /tmp/meb.$$ | /bin/grep "mysqlbackup: MySQL binlog position: filename" | /bin/awk -F' ' '{print $NF}'`
	INCLSN=`/bin/cat /tmp/meb.$$ | /bin/grep "qlbackup: incremental_base_lsn:"  | /bin/awk -F' ' '{print $NF}'`
	logger "backup destination: ${BCKDST}" 1	
	logger "backup binlog filename: ${BINLOGFILE}" 1	
	logger "backup binlog position: ${BINLOGPOS}" 1	
	logger "backup incremental lsn: ${INCLSN}" 1	

	# write an repository file
	repository ${MODE} ${BCKDST} ${BINLOGFILE} ${BINLOGPOS} ${INCLSN}
	}

repository()
	{
	if [ \! -f ${BASEDIR}/repos.lst ]; then
		logger "backup repository does not exists" 2
		logger "creating repository" 2
		echo -e "DATE - MODE - DESTINATION - BINLOGFILE - BINLOGPOS - INCLSN" >  ${BASEDIR}/repos.lst
	else
		echo -e "${DATE} - ${1} - ${2} - ${3} - ${4} - ${5}" >> ${BASEDIR}/repos.lst
	fi
	}

readrepos()
	{
	if [ \! -f ${BASEDIR}/repos.lst ]; then
		logger "no backup repository exists; this is fatal!" 3
	else
		LSN=`/bin/grep "${1}" ${BASEDIR}/repos.lst | /usr/bin/tail -n 1 | /bin/awk -F' ' '{print $NF}'`
		logger "incremental backup starting with LSN: ${LSN}" 1
	fi
	}

cleanout()
	{
	logger "checking redundancy before cleaning backups" 1

	NOBCK=`selectdb "select count(*) from mysql.backup_history where backup_type = 'FULL'"`

	if [ ${NOBCK} -gt ${REDUNDANCY} ]; then
		logger "${NOBCK} backups found; ${REDUNDANCY} required" 1
	else
		logger "${NOBCK} backups found; ${REDUNDANCY} required" 2
		logger "cleanup process stopped" 2
		return 1
	fi

	logger "cleaning old backups" 1
	logger "trying to find backup id" 1

 	PURGEID=`selectdb "select max(backup_id) \
 			from mysql.backup_history \
 				where backup_id <  (select min(backup_id) \
 							from mysql.backup_history \
 								where datediff(now(), start_time) <= ${RETENTION}) \
 				and backup_type = 'FULL'"`

	logger "purging backups up to id: ${PURGEID}" 1

	if [ ${PURGEID} -eq "NULL" ]; then
		logger "no old backups to purge" 1
	else
		logger "extracting backup information" 1

		DELBCK=`selectdb "select concat(backup_id, \"|\",  backup_destination, \"|\", backup_type, \"|\", date_format(start_time, '%Y%m%d%H%i%s')) \
				from mysql.backup_history \
					where backup_id <= ${PURGEID} \
						order by backup_id asc"`

		echo "${DELBCK}" > mj.text
		for backups in `echo ${DELBCK}`
			do
			# logger "found backup: ${backups}" 1

			BCKID=`echo ${backups} | /bin/cut -f1 -d"|"`
			BCKPATH=`echo ${backups} | /bin/cut -f2 -d"|"`
			BCKMODE=`echo ${backups} | /bin/cut -f3 -d"|"`
			BCKTIME=`echo ${backups} | /bin/cut -f4 -d"|"`

			logger "deleting backup: ${BCKPATH}" 1

			# deleting backup folder
			if [ \! -d  ${BCKPATH} ]; then
				logger "cannot delete backup from  ${BCKPATH}; path does not exist" 2
			else
				/bin/rm -r ${BCKPATH}
				logger "backup deleted" 1
			fi

			# deleting from mysql.backup_history
			# selectdb "delete from mysql.backup_history where backup_id = ${BCKID}"

			# deleting from repository file
			/bin/sed "/$${BCKID}/d" ${BASEDIR}/repos.lst > ${BASEDIR}/repos.tmp
			/bin/mv ${BASEDIR}/repos.tmp ${BASEDIR}/repos.lst
			done
	fi

	}

selectdb()
	{
	STMT=${1}
	# logger "executing stmt: ${STMT}" 1
	RC=`${MYSQLBIN}/mysql -u${BCKUSER} -p${BCKPWD} -s -N --execute="${STMT}"`
	echo ${RC}
	}

tidyup()
	{
	# rotate logfile
	FILESIZE=`/usr/bin/stat -c %s ${LOGDIR}/${HOSTNAME}.blog`
	LIMIT=`expr ${MAXLOGSIZE} \* 1024 \* 1024`

	logger "log file size: ${FILESIZE}" 1
	logger "log file size limit: ${LIMIT}" 1

	# tidy up old logfiles
	for file in ` /usr/bin/find ${LOGDIR} -type f -mtime ${LOGAGE}`
		do
		logger "deleteting ${file}" 1
		/bin/rm ${file}
		done
	
	# zip general log if size is above $LIMIT
	if [ ${FILESIZE} -gt ${LIMIT} ]; then
		/usr/bin/bzip2 ${LOGDIR}/${HOSTNAME}.blog
		logger "zipping general log" 1
	fi	


	logger "no# of warnings:\t${WARNINGS}" 1
	logger "no# of errors:\t\t${ERRORS}" 1

	# tidy up meb log info if no error occurred
	if [[ ${WARNINGS} -eq 0 && ${ERRORS} -eq 0 ]]; then
		logger "removing meb log output: ${LOGDIR}/meb.$$" 1
		/bin/rm /tmp/meb.$$
	else
		logger "meb log output is not removed due to an error or warning" 1
		/bin/mv /tmp/meb.$$ ${LOGDIR}/meb.$$
		logger "meb log output ${LOGDIR}/meb.$$" 1
	fi

	# send log info to STDOUT
	/bin/cat ${LOGDIR}/${HOSTNAME}.${DATE}
	}
	

### program
# check if a backup mode was set
if [ -z "${MODE}" ]; then 
	echo -e "no backup mode defined" >&2
	usage
	exit 1
fi

logger "starting backup of ${HOSTNAME} @ ${DATE}" 1
backup
cleanout
tidyup

### program

