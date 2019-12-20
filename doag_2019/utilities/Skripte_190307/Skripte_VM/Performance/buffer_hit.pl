#!/usr/bin/perl -w 

use strict;

$SIG{INT}=\&stop;

print "CH\tCU(%)\t\t\tIBF(MB)\tICH\n";
while ( 1 )
	{
	my $command = "mysql -uroot -Dinformation_schema -N  <<EOF 
	 select 
		100 - ( (select variable_value from global_status where variable_name = 'KEY_READS') / 
			(select variable_value from global_status where variable_name = 'KEY_READ_REQUESTS')
		      ) as Cache_HIT,
		100 - ( (select variable_value from global_status where variable_name = 'KEY_BLOCKS_UNUSED') *
			(select variable_value from global_variables where variable_name = 'KEY_CACHE_BLOCK_SIZE') * 100 /
			(select variable_value from global_variables where variable_name = 'KEY_BUFFER_SIZE')
		      ) as Cache_USED,
			(
			(
			(select variable_value
                        from global_status
                        where variable_name = 'Innodb_buffer_pool_pages_free')*16)/
				
			((select variable_value 
			from global_status 
			where variable_name = 'Innodb_buffer_pool_pages_total')*16)

			)*100,
			100-
			(
			(
			select variable_value from global_status                         where variable_name = 'Innodb_buffer_pool_reads')
			/
			(
			select variable_value from global_status                         where variable_name = 'Innodb_buffer_pool_read_requests')
			)

EOF"; 
	sleep(1);
	print `$command`;
	}


sub stop
	{
	print "STOP";
	exit 0;	
	}
