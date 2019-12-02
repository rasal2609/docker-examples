/********************************************************************
** File: 03_stopqord.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: create a stopword table for fts indices
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/


use innodb_fts;
drop table if exists user_stopword;

# Define a correctly formatted user stopword table
create table innodb_fts.user_stopword(value varchar(30)) engine = innodb;

# Point to this stopword table with "db name/table name"
set global innodb_ft_user_stopword_table = "innodb_fts/user_stopword";

# a server-wide stopword table does exits, too
set global innodb_ft_server_stopword_table = "innodb_fts/user_stopword";

insert into user_stopword values ('in'), ('a'), ('the'), ('an'), ('and');
