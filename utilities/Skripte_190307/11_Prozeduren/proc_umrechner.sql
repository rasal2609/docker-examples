/********************************************************************
** File: 01_umrechner.sql   
** Name: MySQL Administration Workshop (DB-MY-01) / ORDIX AG
** Desc: creates an example procedure based on the database firma
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
drop procedure if exists umrechner;

delimiter |

create procedure umrechner (IN v_manr INT, IN v_faktor decimal(20,10), OUT v_gehalt decimal(9,2))
  sql security invoker
  comment "rechnet gehaelter anhand eines faktors um"
  reads sql data
  begin

  select gehalt * v_faktor into v_gehalt
    from firma.mitarbeiter
      where mitarbeiternr = v_manr;

  end |

delimiter ;

/* call of procedure */
call umrechner(1,2,@neu_gehalt);
select 'neues gehalt: ', @neu_gehalt;
