use parts;

drop procedure if exists addpartition;


delimiter |
create procedure addpartition(v_table varchar(40))
language sql
begin

  declare v_p_name varchar(40);
  declare v_p_method varchar(40);
  declare v_p_exp varchar(100);
  declare v_p_desc int;


select substr(PARTITION_NAME from 2)+1,
       PARTITION_METHOD,
       PARTITION_EXPRESSION,
       PARTITION_DESCRIPTION+1
       into v_p_name, v_p_method, v_p_exp, v_p_desc
         from information_schema.partitions
           where table_name = v_table
           and substr(PARTITION_NAME from 2) = (
              select max(substr(PARTITION_NAME from 2))
                from information_schema.partitions
                 where table_name = v_table );

    set @mysql = concat( 'alter table ',
                        v_table,
                        ' add partition (partition p',
                        v_p_name, ' values less than (',
                        v_p_desc, '));');

    select @mysql;
   -- prepare stmt from @mysql;
   -- execute stmt;

end |
