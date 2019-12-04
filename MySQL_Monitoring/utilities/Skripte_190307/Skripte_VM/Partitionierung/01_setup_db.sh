#!/usr/bin/bash

THIS_YEAR=`/bin/date +'%Y'`
let LAST_YEAR=${THIS_YEAR}-1;
let BEFORE_LAST_YEAR=${LAST_YEAR}-1;

mysql --socket=/tmp/mysql01.sock  <<EOF
create database if not exists parts;

use parts;

drop table if exists myparts;

create table myparts
	(
	nr int auto_increment,
	erhebung date,
	wert varchar(40),
	primary key(nr , erhebung)
	) engine=innodb
partition by range ( year(erhebung) )
	(
	partition p${BEFORE_LAST_YEAR} values less than(${BEFORE_LAST_YEAR}),
	partition p${LAST_YEAR} values less than(${LAST_YEAR}),
	partition p${THIS_YEAR} values less than(${THIS_YEAR}),
	partition pMAX values less than MAXVALUE
	)
;
insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 2 year ), rand(10));
insert into myparts values (null, date_add( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 2 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_add( curdate(), interval 1 year ), rand(10));
EOF

