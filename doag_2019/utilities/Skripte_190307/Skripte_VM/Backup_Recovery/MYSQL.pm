#!/usr/local/bin/perl -w
use strict;

package MYSQL;

### script information #####################################
#
# Author:       Matthias Jung / ORDIX AG
# Version:      1.0 (2008-10-06)
#
# Description:  This package contains some general functions 
#
### variables #############################################
#

my %CNF;
$CNF{tivoli}     = "/pkg/AN-TK/home/comqdp/scripts/msg_tivoli.sh";   # tivoli script

sub problem
	{
	MYSQL::tivoli("MySQL", $_[0], $CNF{tivoli} );
	}

sub master_status
        {
	my $dbh = shift;
        my $sql = $dbh->prepare ( " show master status " );
        $sql->execute();
        my $row = $sql->fetchrow_arrayref();
        my $string =  $$row[0];
        $sql->finish();
        return $string;
        }


sub getpidage
	{
	my $file = shift;

	return ( -M $file ) * 24 * 60 if ( -e $file );
	return 0 if ( ! -e $file );
	}

sub startpos
        {
	my $dbh = shift;	
        my $sql = $dbh->prepare ( " select now() " );
        $sql->execute();
        my $row = $sql->fetchrow_arrayref();
        my $string =  $$row[0];
        $sql->finish();
        return $string;
        }

sub backuptab
        {
        my ($date, $db, $dumpfile, $logfile, $table) = @_;
        open(FH, ">> $table");
        print FH  "$date|$db|$dumpfile|$logfile\n";
        close(FH);
        }


sub syncbcktable
	{
	my $table = shift;
	my @newtab;

	open(TAB, "< $table");
	my @content = <TAB>;
	close TAB;

	for ( @content ) 
		{
		my ($date,$db,$file) = split(/\|/, $_);
		push(@newtab,  $_) if ( -e $file);
		}

	open(TAB, "> $table");
	print TAB @newtab;
	close TAB;
	}

sub findlogs
	{
	my $startlog = shift;
	my $path = shift;
	my $pos;
	my $file;
	my @logs;
	if ( $startlog =~ /(.*\.[0]*)([0-9]+$)/ )
		{
		$file = $1;
		$pos = $2;
		}
	print "File $file Pos $pos\n";

	while ( -e $path."/".$file.$pos )
		{
		print "would you like to apply the following log <Y|N>: ";
		print $path."/".$file.$pos,"\n";
		
		my $answer = <STDIN>;	chomp($answer);
		
		if ($answer =~ m/^y$/i)
			{
			push(@logs, $path."/".$file.$pos);
			print "log applied\n";
			}
		else
			{
			print "process aborted\n";
			last;
			}
		$pos++;
		}
	return @logs;

	}
sub readbackuptab
	{
	my $file = shift;
	logger(*LOG, "backup table could not be found") if ( ! -e $file );

	open(TAB, "< $file") or die ("Fehler");
	my @contents = <TAB>;
	close(TAB);
	
	my %bckinf;

	for ( @contents )
		{
		my ($date, $db, $dump, $logpos) = split(/\|/, $_);
		$bckinf{$db}->{$date}{"dump"}=$dump;
		$bckinf{$db}->{$date}{"logpos"}=$logpos;
		}

	return \%bckinf;
	}
	

sub getargs
	{
	my $args = shift;
	
	for ( @ARGV )
		{
		my ($param, $value) = split(/=/, $_);
	
		${$args}{substr($param,2)} = $value	if ( defined(${$args}{substr($param,2)}) );
		}	

	return %{$args};
	}


sub logger
	{
	my $channel = shift;
	my $string = shift;
	my $date = ` date +"%y-%m-%d %H:%M:%S"`;	 chomp($date);
	print $channel time() . "\t" . $date . "\t" . $string . "\n";
	return 1;
	}	


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


sub rotate
        {
	my $dbh = shift;
        $dbh->do( " flush logs; ") || die "logs could not be rotated: $DBI::errstr\n";
        }

sub slave_status
        {
	my $dbh = shift;
        my $sql = $dbh->prepare ( " show slave status " );
        $sql->execute();
        my $row;
        my %states;
        $row = $sql->fetchrow_hashref();

        my $key;
        for $key ( keys(%$row) )
                {
                        {
                        $states{$key} = $row->{$key};
                        }

                }
        $sql->finish();
        return \%states;
        }

sub tivoli
	{
	my $flag = shift;
	my $msg = shift;
	my $tivoli = shift || $CNF{tivoli};
	chomp($msg);
	`$tivoli $flag "$msg"`;
	}	

sub findpurgelogs
        {
        my $startlog = shift;
        my $path = shift;
        my $pos=0;
        my $file=0;
        my @logs;

        if ( $startlog =~ /(.*\.[0]*)([1-9]+$)/ )
                {
                $file = $1;
                $pos = $2;
                }

        while ( -e $path."/".$file.$pos )
                {
                push(@logs, $path."/".$file.$pos);
                $pos++;
                }
        return @logs;
        }

1;
