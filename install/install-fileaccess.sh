#!/bin/bash

# Installing FTP
apt-get -y install pure-ftpd-common pure-ftpd-mysql

TMPFTP=`mktemp`
cat /etc/default/pure-ftpd-common | sed -e 's/VIRTUALCHROOT=false/VIRTUALCHROOT=true/' > $TMPFTP
cat $TMPFTP > /etc/default/pure-ftpd-common

echo yes > /etc/pure-ftpd/conf/BrokenClientsCompatibility
echo yes > /etc/pure-ftpd/conf/ChrootEveryone
echo yes > /etc/pure-ftpd/conf/DisplayDotFiles
echo yes > /etc/pure-ftpd/conf/DontResolve
echo no > /etc/pure-ftpd/conf/PAMAuthentication
echo 1000000 100 > /etc/pure-ftpd/conf/LimitRecursion
echo 50000 51000 > /etc/pure-ftpd/conf/PassivePortRange
echo 1 > /etc/pure-ftpd/conf/TLS
echo 'ALL:!aNULL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-SSLv3:-EXP:!kEDH' > /etc/pure-ftpd/conf/TLSCipherSuite
ln -s openhcp-bundle.pem /etc/ssl/private/pure-ftpd.pem

# SQL support
cp /etc/pure-ftpd/db/mysql.conf /etc/pure-ftpd/db/mysql.conf.`date +'%Y%m%d%H%M%S'`
cat pure-ftpd/mysql.conf | sed -e 's/SQLPASSWORDPUREFTPD/'${SQLPASSWORDPUREFTPD}'/' > $TMPFTP
cat $TMPFTP > /etc/pure-ftpd/db/mysql.conf

SQL="CREATE USER 'openhcp-pureftpd'@'localhost' IDENTIFIED BY '${SQLPASSWORDPUREFTPD}'; GRANT USAGE ON *.* TO 'openhcp-pureftpd'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT SELECT ON openhcp.* TO 'openhcp-pureftpd'@'localhost'; FLUSH PRIVILEGES;"
echo "$SQL" | mysql mysql

# finish
rm $TMPFTP
systemctl restart pure-ftpd-mysql
