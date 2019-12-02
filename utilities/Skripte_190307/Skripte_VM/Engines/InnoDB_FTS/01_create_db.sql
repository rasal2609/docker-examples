/********************************************************************
** File: 01_create_db.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: create an example db for innodb tulltext indices
** Auth: Matthias Jung
** Date: 07/2021
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/

# create database
drop database if exists innodb_fts;
create database innodb_fts;
use innodb_fts;

# create test table & fill it
create table quotes
  (    id int unsigned auto_increment primary key
    , author varchar(64)   
    , quote varchar(400)
    , source varchar(64)
  ) engine=innodb;

insert into quotes (author, quote, source) values
  ('Abraham Lincoln', 'Fourscore and seven years ago...',
  'Gettysburg Address')
, ('George Harrison', 'All those years ago...', 'Live In Japan')
, ('Arthur C. Clarke', 'Then 10 years ago the monolith was discovered.',
  '2010: The Year We Make Contact')
, ('Benjamin Franklin',
  'Early to bed and early to rise, makes a man healthy, wealthy, and wise.',
  'Poor Richard''s Almanack')
, ('James Thurber',
  'Early to rise and early to bed makes a male healthy and wealthy and dead.',
  'The New Yorker')
, ('K', '1500 hundred years ago, everybody knew that the Earth was the center of the universe.', 'Men in Black');

# create fulltext index
create fulltext index idx on quotes(quote);
