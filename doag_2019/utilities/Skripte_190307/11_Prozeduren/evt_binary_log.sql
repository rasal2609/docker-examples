use mysql;

delimiter |

drop event if exists rotate_binary_log |

create event rotate_binary_log
 on schedule 
  every 10 second
  starts CURRENT_TIMESTAMP + interval 5 second
  ends CURRENT_TIMESTAMP + interval 1 minute
 on completion preserve
 enable 
do
 flush binary logs;
|
