#!/usr/bin/perl -w

use strict;
use warnings;

use DBI;
use DBD::mysql;
use Getopt::Long;



sub Usage
{
    print("
SYNOPSIS

DESCRIPTION

  Monitors global status variables

FLAGS

  help, h      Print this help.
  user, u      User to connect to [root]
  password, p  Password ['']
  host, h      Host [localhost]
  port, P      Port [3306]
  socket,s     Socket [/var/lib/mysql/mysql.sock]
  interval, i  Interval between snaphots [30 sec]
  variables, v  MySQL status variables [uptime]
  

  $0 --user=root --socket=/tmp/mysql.sock --interval=10 --variables=com_select,com_insert

PARAMETERS

  none

");
}

# Process parameters
# ------------------

my $optHelp = 0;
my $optUser = 'root';
my $optPassword = '';
my $optHost = 'localhost';
my $optPort = '3306';
my $optSocket = '';
my $optInterval = 30;
my $optVariables = 'uptime';

my $rc = GetOptions( 'help|?' => \$optHelp
                   , 'user|u=s' => \$optUser
                   , 'password|p=s' => \$optPassword
                   , 'host|h=s' => \$optHost
                   , 'port=i' => \$optPort
                   , 'socket=s' => \$optSocket
                   , 'interval|i=i' => \$optInterval
                   , 'variables|v=s' => \$optVariables
                   );

if ( $optHelp ) {
    &Usage();
    exit(0);

}

if ( ! $rc) {
    &Usage();
    exit(1);
}

if(@ARGV != 0) {
    &Usage();
    exit(2);
}

my ($dbh, $sql, $sth, $param, $value, $samples);

$dbh = DBI->connect("DBI:mysql::$optHost:$optPort:mysql_socket=$optSocket"
                  , $optUser, $optPassword
                  , { RaiseError => 1 }
                   );

my @inlist = split(/,/, $optVariables);

my $operator = "'".join("','", @inlist)."'";

$sql = "select variable_name, variable_value from information_schema.global_status where variable_name in ($operator)";


$sth = $dbh->prepare( $sql );
if ( ! $dbh) {
  print("Error preperation: ", $dbh->errstr(), "\n");
  exit(3);
}



while ( 1 )
	{
	$sth->execute();
		if (! $sth ) 
		{
		print("Error execute: ", $sth->errstr(), "\n");
		exit(4);
		}



	$sth->bind_columns(\$param, \$value);
	while( $sth->fetchrow_arrayref ) 
		{
		pop(@{$samples->{$param}}) if ( defined  @{$samples->{$param}} && @{$samples->{$param}} >= 10 );
		unshift(@{$samples->{$param}},$value);

		if ( @{$samples->{$param}} > 1 )
			{
			
			my $stat='';	
			$stat="(".(${$samples->{$param}}[0] - ${$samples->{$param}}[@{$samples->{$param}}-1])." last 10 samples)" if ( @{$samples->{$param}} == 10 );
			print STDERR "$param: ", (${$samples->{$param}}[0] - ${$samples->{$param}}[1]), " in $optInterval sec. ",$stat,"\n";
			}
		}
		sleep $optInterval;
		print "#" x --$ENV{LINES}, "\n";
		$sth->finish;
	}

$dbh->disconnect;

exit(0);
