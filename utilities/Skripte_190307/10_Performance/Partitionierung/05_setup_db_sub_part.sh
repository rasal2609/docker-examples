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
	partition by range(year(erhebung))
	subpartition by hash(month(erhebung))
	(
	partition p${BEFORE_LAST_YEAR} values less than (${BEFORE_LAST_YEAR})
		(
		subpartition p${BEFORE_LAST_YEAR}_1,
		subpartition p${BEFORE_LAST_YEAR}_2,
		subpartition p${BEFORE_LAST_YEAR}_3,
		subpartition p${BEFORE_LAST_YEAR}_4,
		subpartition p${BEFORE_LAST_YEAR}_5,
		subpartition p${BEFORE_LAST_YEAR}_6,
		subpartition p${BEFORE_LAST_YEAR}_7,
		subpartition p${BEFORE_LAST_YEAR}_8,
		subpartition p${BEFORE_LAST_YEAR}_9,
		subpartition p${BEFORE_LAST_YEAR}_10,
		subpartition p${BEFORE_LAST_YEAR}_11,
		subpartition p${BEFORE_LAST_YEAR}_12
		),
	partition p${LAST_YEAR} values less than (${LAST_YEAR})
		(
		subpartition p${LAST_YEAR}_1,
		subpartition p${LAST_YEAR}_2,
		subpartition p${LAST_YEAR}_3,
		subpartition p${LAST_YEAR}_4,
		subpartition p${LAST_YEAR}_5,
		subpartition p${LAST_YEAR}_6,
		subpartition p${LAST_YEAR}_7,
		subpartition p${LAST_YEAR}_8,
		subpartition p${LAST_YEAR}_9,
		subpartition p${LAST_YEAR}_10,
		subpartition p${LAST_YEAR}_11,
		subpartition p${LAST_YEAR}_12
		),
	partition p${THIS_YEAR} values less than (${THIS_YEAR})
		(
		subpartition p${THIS_YEAR}_1,
		subpartition p${THIS_YEAR}_2,
		subpartition p${THIS_YEAR}_3,
		subpartition p${THIS_YEAR}_4,
		subpartition p${THIS_YEAR}_5,
		subpartition p${THIS_YEAR}_6,
		subpartition p${THIS_YEAR}_7,
		subpartition p${THIS_YEAR}_8,
		subpartition p${THIS_YEAR}_9,
		subpartition p${THIS_YEAR}_10,
		subpartition p${THIS_YEAR}_11,
		subpartition p${THIS_YEAR}_12
		),
	partition pMAX values less than MAXVALUE
		(
		subpartition p${MAX_YEAR}_1,
		subpartition p${MAX_YEAR}_2,
		subpartition p${MAX_YEAR}_3,
		subpartition p${MAX_YEAR}_4,
		subpartition p${MAX_YEAR}_5,
		subpartition p${MAX_YEAR}_6,
		subpartition p${MAX_YEAR}_7,
		subpartition p${MAX_YEAR}_8,
		subpartition p${MAX_YEAR}_9,
		subpartition p${MAX_YEAR}_10,
		subpartition p${MAX_YEAR}_11,
		subpartition p${MAX_YEAR}_12
		)
	);

insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 2 year ), rand(10));
insert into myparts values (null, date_add( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 2 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_sub( curdate(), interval 1 year ), rand(10));
insert into myparts values (null, date_add( curdate(), interval 1 year ), rand(10));
EOF

