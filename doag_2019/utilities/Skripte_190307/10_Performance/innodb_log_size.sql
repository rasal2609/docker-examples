use performance_schema;

# get start value
select variable_value into @startval from global_status where variable_name = 'InnoDB_OS_Log_written';
update sakila.actor set last_name = last_name where actor_id!=1;

# create some data
# do not use in production
create database if not exists test;
create table if not exists test.dummy ( a char(200));
insert into test.dummy values (1), (2), (3), (4), (5), (6), (7), (8), (9);

# wait period
select sleep(10);

# get end value
select variable_value into @endval from global_status where variable_name = 'InnoDB_OS_Log_written';

# calculate log file size
select (@endval - @startval) * 360 / 1024  as "InnoDB_Log_File_Size_in_KB"; 