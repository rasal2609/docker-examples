use parts;
select * 
	from myparts 
	where erhebung between concat(year(date_sub( curdate(), interval 1 year )), '-01-01')
			 and concat(year(date_sub( curdate(), interval 0 year )), '-12-31') \G
explain select * 
	from myparts 
	where erhebung between concat(year(date_sub( curdate(), interval 1 year )), '-01-01')
			 and concat(year(date_sub( curdate(), interval 0 year )), '-12-31') \G
