/********************************************************************
** File: 02_umrechner.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: calls the created procedure umrechner
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/
use firma;

call umrechner(1,2,@neu_gehalt);
select 'neues gehalt: ', @neu_gehalt;
