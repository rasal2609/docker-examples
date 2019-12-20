#
# Matthias Jung / ORDIX AG
#

select 1 - 
(select variable_value from information_schema.global_status where variable_name = 'Innodb_buffer_pool_reads') /
(select variable_value from information_schema.global_status where variable_name = 'Innodb_buffer_pool_read_requests') "LOGICAL IO RATIO (%)"
