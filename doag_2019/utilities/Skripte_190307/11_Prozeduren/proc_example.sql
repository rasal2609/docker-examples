delimiter //
DROP  PROCEDURE dorepeat //
CREATE PROCEDURE dorepeat(IN startval INT)
     sql security invoker
     no sql
     BEGIN
       SET @x = 0;
       REPEAT SET @x = @x + 1; UNTIL @x > startval END REPEAT;
      END
//
    
call dorepeat(10);
select @x "max value";
