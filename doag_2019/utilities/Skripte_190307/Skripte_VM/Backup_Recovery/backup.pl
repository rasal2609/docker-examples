#!/usr/local/bin/perl -w

use strict;
use DBI;
use MYSQL;

$SIG{__DIE__} = \&MYSQL::problem;

### script information #####################################
#
# Author:       Matthias Jung / ORDIX AG
# Version:      1.0 (2007-04-03)
#               1.1 (2007-04-08): added logger routine
#		1.2 (2007-04-09): added getargs routine
#		
# Description:  This script will make backups of any mysql database.
#               It uses the default mysql backup tool "mysqldump".
#               It simply flushes all tables to disk, locks them
#               and starts the backup. Additionally it points out
#               the binary logs you will need to restore your (only for INNODB-tables)
#               database -> that is why you should enable the parameter log-bin.
# Requirements: - User account to perform backups (e.g. root or similar) -> e.g. at end of this script
#               - Parameter log-bin (/etc/my.cnf) should be set for your mysql installation
#               - the following variables should be set accuratly
#
### variables #############################################
#                                                         
my %CNF;
   $CNF{user}       = "dump";				  		# mysql user account; needs dba privs
   $CNF{password}   = "dump";				  		# name of database you want to backup
   $CNF{db}	    = "mysql";				  		# password for useraccount
   $CNF{bck_path}   = "/home/mysql/backup/backups";		  	# backups are writtem here
   $CNF{log}        = "/home/mysql/backup/backup.blog";			# where do you want your log information
   $CNF{path}       = "/opt/mysql/mysql-5.5.24/bin";		  	# where is mysql installed
   $CNF{my_cnf}     = "/etc/my.cnf";				  	# where is you mysql conf (/etc/my.cnf)
   $CNF{backuptab}  = "/home/mysql/backup/bckuptab.csv"; 	 	# list of taken backup
   $CNF{slave}	    = 1;						# 1 => System is a slave; 0 => no slave system
   $CNF{pid}	    = "/tmp";						# Path to PID-file

#                                                         
# all variables can be replaced/changed by shell parameters
# e.g.: shell> perl backup.pl --db=test --user=root --password=secret --log=mylog.txt
#
### programm ##############################################
#

# write pid file
my $prog;
if ( $0  =~ m/^.*\/([^\/]+)$/ )
	{
	$prog = $1;
	}	

open(FH, "> $CNF{pid}/$prog.pid");
print FH $$;
close(FH);

# mysql configuration
my $mysql_conf = "mysql_read_default_group=client;mysql_read_default_file=$CNF{my_cnf}";

# read in shell parameters
%CNF = MYSQL::getargs(\%CNF);

my $date = ` date +"%y%m%d%H%M%S"`;	 chomp($date);
my $start = time();

open(LOG, ">> $CNF{log}") || die "cannot write to log file\n";
my $dbh = DBI->connect( "dbi:mysql:$CNF{db};$mysql_conf", "$CNF{user}", "$CNF{password}") || die("cannot connect to DB $CNF{db}");
MYSQL::logger(*LOG, "#" x 40);
MYSQL::logger(*LOG, "start backup of database $CNF{db}");

# stop slave if required
$dbh->do( " stop slave sql_thread " ) if ( $CNF{slave} );
MYSQL::logger(*LOG, "NOTICE: slave stopped");

# lock all tables in the database
### $dbh->do( " flush tables with read lock; " ) || die "tables could not be flushed and locked: $DBI::errstr\n";
### MYSQL::logger(*LOG, "tables flushed and locked");

# rotate logs
MYSQL::rotate($dbh);
MYSQL::logger(*LOG, "binary logs rotated BEFORE backup");
MYSQL::logger(*LOG, "new logfile: " . MYSQL::master_status($dbh) );

# start backup
MYSQL::logger(*LOG, "start backup")     unless  ( system( "$CNF{path}/mysqldump -q $CNF{db} -u$CNF{user} -p$CNF{password} > $CNF{bck_path}/bck_${date} " ) );
MYSQL::logger(*LOG, "backup failure") 	 if      ( system( "$CNF{path}/mysqldump $CNF{db} -u$CNF{user} -p$CNF{password} > $CNF{bck_path}/bck_${date} " ) );

# end backup
MYSQL::logger(*LOG, "backup done");

# rotate logs
MYSQL::rotate($dbh);
MYSQL::logger(*LOG, "binary logs rotated AFTER backup");
MYSQL::logger(*LOG, "new logfile: " . MYSQL::master_status($dbh) );
MYSQL::logger(*LOG, "NOTICE: you will need all logs containing information from this timestamp: " . time());
$CNF{startpos} = MYSQL::startpos($dbh);
MYSQL::logger(*LOG, "NOTICE: this is equivalent to the following date: " . $CNF{startpos} );
MYSQL::logger(*LOG, "NOTICE: you will find these information from " . MYSQL::master_status($dbh) . " and on...");

# to clearly separate transactions from the end of the backup set we will wait a little bit
sleep 3;

# unlock all tables in the database
### $dbh->do( " unlock tables; " ) || die "tables could not be unlocked: $DBI::errstr\n";
### MYSQL::logger(*LOG, "tables unlocked");

# start slave if required
$dbh->do( " start slave sql_thread " ) if ( $CNF{slave} );
MYSQL::logger(*LOG, "NOTICE: slave startet");

MYSQL::logger(*LOG, "end of backup database $CNF{db}");
MYSQL::logger(*LOG, "duration of backup: ". ( time() - $start ) . " sec.");

MYSQL::backuptab($CNF{startpos}, $CNF{db}, $CNF{bck_path}."/bck_".${date}, MYSQL::master_status($dbh),$CNF{backuptab});


$dbh->disconnect();
close(LOG);


########################################################################################################################################
# Example of backup user                                                                                                               #
# +----------------------------------------------------------------------------------------------------------------------------------+ #
# | Grants for dump@localhost                                                                                                        | #
# +----------------------------------------------------------------------------------------------------------------------------------+ #
# | GRANT RELOAD, SUPER, LOCK TABLES ON *.* TO 'dump'@'localhost' IDENTIFIED BY PASSWORD '*619ED90CE68FC6009CF3B3D25FF263D4588A667B' | #
# | GRANT SELECT ON `<DB_YOU_WANT_TO_BACKUP>`.* TO 'dump'@'localhost'                                                                | #
# +----------------------------------------------------------------------------------------------------------------------------------+ #
########################################################################################################################################
