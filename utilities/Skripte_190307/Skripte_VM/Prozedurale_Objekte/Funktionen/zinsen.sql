/********************************************************************
** File: zinsen.sql   
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
 
drop function if exists zinsen;

delimiter |

create function zinsen(betrag decimal(9,2), zinssatz int, anlagedauer int)
  returns decimal(9,2)
  reads sql data
    begin
    declare v_betrag decimal(15,2);

    set v_betrag= betrag * pow(( 1 + ( zinssatz / 100 )), anlagedauer);

    return v_betrag;
    end |

delimiter ;
