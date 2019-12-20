/********************************************************************
** File: security_check.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: 
** Auth: Matthias Jung
** Date: 07/2012
/********************************************************************
** Change History
/********************************************************************
**  #   Date        Author      Description 
** --   ----------  -------     ------------------------------------
** 01   27/07/2012  Jung        1st. version
/*******************************************************************/

/* secure your server /**********************************************
- install the latest patches
- use SSH
- activate a firewall
- disable unneeded services
- ...
/*******************************************************************/
select 'Is your server secure?';

/* check your network setting /*************************************
- --skip-networking
- --bind-adderess
- ...
/*******************************************************************/
select if (variable_value = 'OFF', 'Your server is accessible via network', 'Your server does not use networking')
    from information_schema.global_variables where variable_name = 'skip_networking';
select if (variable_value = '', 'Ýour server is accessible via all server ip addresses', 'You defined a bind-address.')
    from information_schema.global_variables where variable_name = 'bind_address';
    
/* check local infile parameter /***********************************
- --local_infile
- --secure_file_priv
- ...
/*******************************************************************/    
select if (variable_value = 'ON', 'Local infiles are currently supported.', 'Local infiles are currently not supported.')
    from information_schema.global_variables where variable_name = 'local_infile';
select if (variable_value = '', 'There is no path definition.', 'You defined a secure path.')
    from information_schema.global_variables where variable_name = 'secure_file_priv';
    
/* check user accounts /******************++++++++++*****************
- check accounts without passwords
- check accounts with system privileges
- check accounts with database privileges
- checl accounts with privileges on mysql.user
/*******************************************************************/     
select if(count(*) >0, 'There are accounts without passwords', 'All accounts seem to have passwords.') from mysql.user where password = '' having count(*) > 0;

select  "system wide dml privs" as "message",
        concat(user, '@', host) as "user name", 
        case when password != '' then 'Y' else 'N' end as "having password" 
            from mysql.user 
                where insert_priv = 'Y' 
                or update_priv = 'Y' 
                or delete_priv = 'Y';
                
select  "privs in mysql db" as "message",
        concat(user, '@', host) as "user name", 
        (select case when password != '' then 'Y' else 'N' end from mysql.user user where user.user = db.user and user.host = db.host) as "having password"
            from mysql.db db
                where db = 'mysql';

                
select  "privs on table mysql.user" as "message",
        concat(user, '@', host) as "user name", 
        (select case when password != '' then 'Y' else 'N' end from mysql.user user where user.user = table_priv.user and user.host = table_priv.host) as "having password"
            from mysql.tables_priv table_priv
                where table_name = 'user';
                
/* check test db /***************************************************
- ...
/*******************************************************************/    
select if (schema_name = 'test', 'Consider dropping "test" db.', 'No "test" db exists') from information_schema.schemata where schema_name = 'test';

/* enable logging /***********************++++++++++*****************
- ...
/*******************************************************************/  
select if (variable_value = 'OFF', 'Your are currently not logging.', 'Your are using loggig.')
    from information_schema.global_variables where variable_name = 'general_log';
    
/* backup your system **********************************************
- log-bin should be active when PIT is needed
/******************************************************************/
select if (variable_value = 'OFF', 'Check your backup concept (PIT is not possible).', 'Binary logging ist active, so PIT is possible.')
    from information_schema.global_variables where variable_name = 'log_bin';
