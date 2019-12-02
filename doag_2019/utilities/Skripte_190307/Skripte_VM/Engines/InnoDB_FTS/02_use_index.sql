/********************************************************************
** File: 02_use_index.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: example queries using the fts index
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

# normal query
select author from quotes
  where match(quote) against ('monolith' in natural language mode);

# bolean query
select author, quote  from quotes
  where match(quote) against ('+ago +years' in boolean mode);

# proximity serach; the two strings must be within x bytes (in this case 100)
select quote as "Too Far Apart" from quotes
  where match(quote) against ('"early wise" @100' in boolean mode);
