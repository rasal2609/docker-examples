# using mysqlslap

/opt/mysql/bin/mysqlslap --delimiter=";" --create="DROP TABLE IF EXISTS test.A;CREATE TABLE test.A (B INT);insert into test.A values (23)" --query="select * from test.A" --concurrency=50 --iterations=200
