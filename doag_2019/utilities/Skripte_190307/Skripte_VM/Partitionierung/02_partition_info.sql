use parts;

select partition_name, partition_expression, table_rows 
	from information_schema.partitions 
		where table_schema='parts';
