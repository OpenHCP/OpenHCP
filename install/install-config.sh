#!/bin/bash

SSLCERTPATH="/etc/ssl/certs/openhcp.pem"
SSLKEYPATH="/etc/ssl/private/openhcp.key"

# generate random password for MariaDB
SQLPASSWORD=`tr -dc 'a-zA-Z0-9' < /dev/random | fold -w 16 | head -n 1`
export SQLPASSWORD
touch ~/.my.cnf
chmod 600 ~/.my.cnf
echo '[client]
user = root
password = "'${SQLPASSWORD}'"' >> ~/.my.cnf

# gets domainname.hostname
MAILNAME="`hostname`.`hostname -d`"
export MAILNAME

# generate postfix password for MariaDB
SQLPASSWORDPOSTFIX=`tr -dc 'a-zA-Z0-9' < /dev/random | fold -w 16 | head -n 1`
export SQLPASSWORDPOSTFIX

# generate dovecot password for MariaDB
SQLPASSWORDDOVECOT=`tr -dc 'a-zA-Z0-9' < /dev/random | fold -w 16 | head -n 1`
export SQLPASSWORDDOVECOT

# generate pure-ftpd password for MariaDB
SQLPASSWORDPUREFTPD=`tr -dc 'a-zA-Z0-9' < /dev/random | fold -w 16 | head -n 1`
export SQLPASSWORDPUREFTPD

# generate amavisd-new password for MariaDB
SQLPASSWORDAMAVIS=`tr -dc 'a-zA-Z0-9' < /dev/random | fold -w 16 | head -n 1`
export SQLPASSWORDAMAVIS
