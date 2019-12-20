/********************************************************************
** File: read_write_physical.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: information about the io pattern (physical / logical)
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************


SELECT sum(SUM_NUMBER_OF_BYTES_READ) /  sum(SUM_NUMBER_OF_BYTES_READ + SUM_NUMBER_OF_BYTES_WRITE) as "RBYTES %", 
sum(SUM_NUMBER_OF_BYTES_WRITE) /  sum(SUM_NUMBER_OF_BYTES_READ + SUM_NUMBER_OF_BYTES_WRITE) as "WBYTES %"
    FROM performance_schema.file_summary_by_instance;
    
    
   