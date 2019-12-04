#
# Matthias Jung, Raphael Salguero / ORDIX AG
#
#!/bin/bash

INSERT_QUERY="insert into sakila.rental(rental_date, inventory_id, customer_id, return_date, staff_id) values (sysdate(), 1000, 100, sysdate()+3, 1);
insert into sakila.rental(rental_date, inventory_id, customer_id, return_date, staff_id) values (sysdate(), 2000, 200, sysdate()+3, 1);
insert into sakila.rental(rental_date, inventory_id, customer_id, return_date, staff_id) values (sysdate(), 3000, 300, sysdate()+3, 2);
insert into sakila.rental(rental_date, inventory_id, customer_id, return_date, staff_id) values (sysdate(), 4000, 400, sysdate()+3, 2);"

echo "Aktuelles Binary-Log:"
mysql -uroot -s -N --execute="show master status";

echo "Inserts.."
mysql -uroot -s -N --execute="$INSERT_QUERY; flush binary logs;"

sleep 2

mysql -uroot -s -N --execute="$INSERT_QUERY; flush binary logs;"

sleep 2

mysql -uroot -s -N --execute="$INSERT_QUERY; flush binary logs;"

echo "Neues Binary-Log:"
mysql -uroot -s -N --execute="show master status";
