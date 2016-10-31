#!/bin/bash

apt-get update
apt-get -y upgrade

# netselect-apt
apt-get -y install netselect-apt
TMPAPT="/tmp/netselect-"$RANDOM
netselect-apt -n -o $TMPAPT
cat $TMPAPT > /etc/apt/sources.list.d/openhcp.list
rm -f $TMPAPT
echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list.d/openhcp.list
apt-get update

# make sure there's enough entropy, current time and some utils
apt-get -y install haveged ntpdate debconf-utils sudo debian-keyring debianutils needrestart git debian-goodies

# make sure the time is current
ntpdate-debian
# different minute, so we don't kill NTP servers ;)
echo `expr ${RANDOM:1:2} % 60`' *	* * *	root	/usr/sbin/ntpdate-debian 2>/dev/null >/dev/null' > /etc/cron.d/openhcp-ntpdate

# install SSH client and server
apt-get -y install ssh openssh-blacklist openssh-blacklist-extra ssl-cert
# make sure we have all keys for server
ssh-keygen -A

# add openhcp user
useradd -c OpenHCP -d /var/openhcp -M -s /bin/false openhcp
mkdir -p /var/openhcp/
chown openhcp.openhcp /var/openhcp
