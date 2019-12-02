use sakila;

# 1st run
clear
flush status;
show local status like 'Sort_merge_passes';

select "sleep 5 secs" as message;
select sleep(5);
select * from rental a order by 2,3;

show local status like 'Sort_merge_passes';

select "sleep 5 secs" as message;
select sleep(5);

# 2nd run
clear
set local sort_buffer_size=5*1024*1024;

flush status;
show local status like 'Sort_merge_passes';

select "sleep 5 secs" as message;
select sleep(5);
select * from rental a order by 2,3;

show local status like 'Sort_merge_passes';
