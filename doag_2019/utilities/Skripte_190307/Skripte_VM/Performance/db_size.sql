/********************************************************************
** File: db_size.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: get db sizes
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/



SELECT 	table_schema "DB-Name",
	sum( data_length + index_length ) / 1024 / 1024 "DB Size (MB)",
	sum( data_free )/ 1024 / 1024 "Free (MB)"
		FROM information_schema.TABLES
			GROUP BY table_schema ; 
