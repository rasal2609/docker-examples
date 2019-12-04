create database grafana;

create user 'grafana'@'%' identified by 'grafana';
grant all privileges on *.* to 'grafana'@'%';

create user 'exporter'@'%' identified by 'exporter';
grant all privileges on *.* to 'exporter'@'%';
