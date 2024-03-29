#!/bin/bash

. .proxy_env
SCRIPT="/opt/mysql/mysql-proxy-0.8.2/share/doc/mysql-proxy/auditing.lua"

${MYSQL_PROXY} --proxy-backend-addresses=${IP}:3306 \
--proxy-lua-script=${SCRIPT} \
--proxy-address=${IP}:3399 \
--pid-file=/opt/mysql/mysql-proxy-0.8.2/proxy.pid \
--log-level=debug \
--log-file=/opt/mysql/mysql-proxy-0.8.2/proxy.log
