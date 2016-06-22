#!/bin/bash

# quiet install
echo "mariadb-server-10.0	mysql-server/root_password_again	password	${SQLPASSWORD}" | debconf-set-selections
echo "mariadb-server-10.0	mysql-server/root_password	password	${SQLPASSWORD}" | debconf-set-selections
apt-get -y install mariadb-client mariadb-server

# clean password
echo "mariadb-server-10.0	mysql-server/root_password_again	password	" | debconf-set-selections
echo "mariadb-server-10.0	mysql-server/root_password	password	" | debconf-set-selections

SQL="DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE test; DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; FLUSH PRIVILEGES;"

SQL="CREATE DATABASE openhcp DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;"
echo "$SQL" | mysql mysql

mysql openhcp < mariadb/base.sql

# only for multi-server
#echo 'bind-address = 0.0.0.0' >> /etc/mysql/conf.d/openhcp.cnf

# TODO - firewall
#systemctl restart mysql
