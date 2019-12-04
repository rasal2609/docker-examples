/********************************************************************
** File: lock_user.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: the script creates lock statements for users without pwd 
**       (version > 5.6.6 needed)
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   26/07/2012  Jung        1st. version
/*******************************************************************/



select concat('ALTER USER ''', user, '''@''', host, ''' PASSWORD EXPIRE;') from mysql.user where password = '' and user != 'root';
