#!/usr/local/bin/perl 

use strict;
use MYSQL;

### script information #####################################
#
# Author:       Matthias Jung / ORDIX AG
# Version:      1.0 (2008-10-06)
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
   $CNF{bck_path}   = "/home/mysql/backup/backups";		  	# backups are writtem here
   $CNF{log}        = "/home/mysql/backup/restore.blog";		# where do you want your log information
   $CNF{logpath}    = "/mysql/data01";					# path to binary logs
   $CNF{path}       = "/opt/mysql/mysql-5.5.24/bin";		  	# where is mysql installed
   $CNF{my_cnf}     = "/etc/my.cnf";				  	# where is you mysql conf (/etc/my.cnf)
   $CNF{backuptab}  = "/home/mysql/backup/bckuptab.csv"; 	 	# list of taken backup
#                                                         
# all variables can be replaced/changed by shell parameters
# e.g.: shell> perl backup.pl --db=test --user=root --password=secret --log=mylog.txt
#
### programm ##############################################
#

open(LOG, ">> $CNF{log}") || die "cannot write to log file\n";
MYSQL::logger(*LOG, "#" x 40);
MYSQL::logger(*LOG, "reading backup table");
my $backups = MYSQL::readbackuptab($CNF{backuptab});

my @databases = keys(%$backups);

print "select database:\n";
map{ print "\t$_\n" } @databases;
print "> ";
my $database = <STDIN>;	chomp($database);

unless ( grep(/$database/, @databases) ) 
	{
	print STDERR "database $database not in backup table\n";
	MYSQL::logger(*LOG, "database $database not in backup table");
	exit 2;
	}

print "available backups:\n";
my @availdates = sort(keys(%{$backups->{$database}}));
map{ print "\t$_\n" } @availdates;
print "> ";
my $date = <STDIN>;	chomp($date);

unless ( grep(/$date/, @availdates) ) 
	{
	print STDERR "date $date not in backup table\n";
	MYSQL::logger(*LOG, "date $date not in backup table");
	exit 2;
	}


# get information for selected backup
print "backup information:\n";
my $dump = %{$backups->{$database}}->{$date}{dump};
my $startlog = %{$backups->{$database}}->{$date}{logpos};
print "dump file: $dump\n";
print "start log file: $startlog\n";

# check if database is running
mysqlstate();

# find binary logs
my @logs = MYSQL::findlogs($startlog, $CNF{logpath});

# write restore file
print "enter filename for restore file >";
my $restorefile = <STDIN>;	chomp($restorefile);

# collect restore information
my @restore;

if ( ! -e $dump )
	{
	print STDERR "dump file $dump could not be found\n";
	MYSQL::logger(*LOG, "dump file $dump could not be found");
	exit 2;
	}

#open(RESTORE, "< $dump");
#my @content = <RESTORE>;
#push(@restore, @content);
#MYSQL::logger(*LOG, "dump file $dump opened");

`cp $dump $restorefile`;

for ( (@logs) )
	{
	my @content = `$CNF{path}/mysqlbinlog -d $database $_`;
	MYSQL::logger(*LOG, "$CNF{path}/mysqlbinlog -d $database $_");
	push(@restore, @content);
	} 

# deactivate bin log for restore;
# unshift(@restore, "SET SQL_LOG_bin=0;\n\n");
print STDOUT "parameter SQL_LOG_BIN has been deactivated in restore file\n";

open(RESTORE, ">> $restorefile");
print RESTORE @restore;
close(RESTORE);



close(LOG);


### functions ##############################################

sub mysqlstate
	{
	my @rc = `ps -ef | grep mysqld | grep -v grep`;

	if ( @rc > 0 )
		{
		print STDERR "WARNING: mysql is alive\nPlease remember that the last binary log is in use by mysql and should no be applied.\n";
		print "press enter to contiune\n";
		<STDIN>;
		}
	}
