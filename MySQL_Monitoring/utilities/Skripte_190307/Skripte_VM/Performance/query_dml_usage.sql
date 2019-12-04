/********************************************************************
** File: query_dml_usage.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: performance about the dml / query ratio
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************-

select 
(select variable_value 
    from performance_schema.global_status 
        where variable_name like 'COM_SELECT'
) 
/
(select sum(variable_value) 
    from performance_schema.global_status 
        where variable_name in ('COM_INSERT', 'COM_UPDATE', 'COM_DELETE', 'COM_SELECT')
) as "SELECT %",
(
select sum(variable_value) 
    from performance_schema.global_status 
        where variable_name in ('COM_INSERT', 'COM_UPDATE', 'COM_DELETE')
)
/
(select sum(variable_value) 
    from performance_schema.global_status 
        where variable_name in ('COM_INSERT', 'COM_UPDATE', 'COM_DELETE', 'COM_SELECT')
) as "DML %"
        ;
