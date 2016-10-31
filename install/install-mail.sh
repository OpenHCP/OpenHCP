#!/bin/bash

echo "postfix	postfix/mailname	string	${MAILNAME}" | debconf-set-selections
echo "postfix	postfix/main_mailer_type	select	Internet Site" | debconf-set-selections
apt-get -y install postfix postfix-mysql ca-certificates openssl-blacklist openssl-blacklist-extra postfix-policyd-spf-python

# installing Dovecot
apt-get -y install dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd dovecot-managesieved

# installing archive tools
apt-get -y install zoo unzip bzip2 arj nomarch lzop cabextract zip lhasa xz-utils p7zip rpm alien p7zip-full liblz4-tool lrzip

# installing RAR - nonfree
apt-get -y install unrar rar p7zip-rar

# installing spam killers
apt-get -y install amavisd-new spamassassin clamav clamav-daemon razor pyzor
# enable spam and virus detection in amavis
cat amavis/60-openhcp | sed -e 's/SQLPASSWORDAMAVIS/'${SQLPASSWORDAMAVIS}'/' > /etc/amavis/conf.d/60-openhcp
SQL="CREATE USER 'openhcp-amavis'@'localhost' IDENTIFIED BY '${SQLPASSWORDAMAVIS}'; GRANT USAGE ON *.* TO 'openhcp-amavis'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT SELECT ON openhcp.* TO 'openhcp-amavis'@'localhost'; FLUSH PRIVILEGES;"
echo "$SQL" | mysql mysql
SQL=
systemctl restart amavis

# stop spamassassin's spamd - not needed since we use amavis
service spamassassin stop
systemctl disable spamassassin

# fix clamav
usermod -a -G amavis clamav
systemctl restart clamav-daemon

# postfix
SQL="CREATE USER 'openhcp-postfix'@'%' IDENTIFIED BY '${SQLPASSWORDPOSTFIX}'; GRANT USAGE ON *.* TO 'openhcp-postfix'@'%' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT SELECT ON openhcp.* TO 'openhcp-postfix'@'%'; FLUSH PRIVILEGES;"
echo "$SQL" | mysql mysql
SQL=

# postfix/main.cf
POSTFIXMAIN=`mktemp`
cp /etc/postfix/main.cf /etc/postfix/main.cf.`date +'%Y%m%d%H%M%S'`
cat /etc/postfix/main.cf | \
	sed -e 's/smtpd_tls_cert_file/#smtpd_tls_cert_file/' | \
	sed -e 's/smtpd_tls_key_file/#smtpd_tls_key_file/' > $POSTFIXMAIN
cat postfix/main.cf >> $POSTFIXMAIN
cat $POSTFIXMAIN > /etc/postfix/main.cf

# postfix/virtual*
for VIRTFILES in `ls -1 postfix | egrep '^mysql-virtual_'`; do
	cat postfix/$VIRTFILES | \
	sed -e 's/DBHOST/localhost/' | \
	sed -e 's/DBUSER/openhcp-postfix/' | \
	sed -e 's/DBPASS/'${SQLPASSWORDPOSTFIX}'/' | \
	sed -e 's/DBNAME/openhcp/' > /etc/postfix/$VIRTFILES
done

# postfix/master.cf
cat postfix/master.cf >> /etc/postfix/master.cf

# dovecot
cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.`date +'%Y%m%d%H%M%S'`
cat dovecot/dovecot.conf > /etc/dovecot.conf
SQL="CREATE USER 'openhcp-dovecot'@'localhost' IDENTIFIED BY '${SQLPASSWORDDOVECOT}'; GRANT USAGE ON *.* TO 'openhcp-dovecot'@'localhost' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; GRANT SELECT ON openhcp.* TO 'openhcp-dovecot'@'localhost'; FLUSH PRIVILEGES;"
echo "$SQL" | mysql mysql
SQL=
cat dovecot/dovecot-sql.conf | sed -e 's/SQLPASSWORDDOVECOT/'${SQLPASSWORDDOVECOT}'/' > /etc/dovecot/dovecot-sql.conf
# global sieve: SPAM -> Junk
cat dovecot/global.sieve > /var/openhcp/global.sieve
sievec /var/openhcp/global.sieve

systemctl restart dovecot

# WIP
# https://easyengine.io/tutorials/mail/server/sieve-filtering/
# http://wiki2.dovecot.org/Pigeonhole/Sieve/Configuration

# policyd + SQL - TODO
