#!/bin/bash

if [ "`id -u`" -ne "0" ]; then
	echo "This installer must me run as root."
	exit
fi

CURDIR=`dirname $0`
cd $CURDIR

. install-config.sh

./install-base.sh
./install-check.sh
./install-quota.sh

./install-db.sh
echo "MariaDB root password: ${SQLPASSWORD}"

./install-dns.sh
./install-mail.sh
echo "Server mail name: ${MAILNAME}"

./install-www.sh
./install-fileaccess.sh
./install-stats.sh
./install-security.sh
./install-gui.sh
