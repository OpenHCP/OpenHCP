#!/bin/bash

# installing fail2ban
apt-get -y install fail2ban
cat fail2ban/jail.local >> /etc/fail2ban/jail.local
echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf
systemctl restart fail2ban

# grsecurity from backports
if [ "`dpkg --print-architecture`" -eq "i386" ]; then
	apt-get -y install linux-image-grsec-i386 gradm2 paxctl
fi

if [ "`dpkg --print-architecture`" = "amd64" ]; then
	apt-get -y install linux-image-grsec-amd64 gradm2 paxctl
fi

# Debian hardening
# FIXME - tripwire needs more of my love
#tripwire        tripwire/local-passphrase-again password        
#tripwire        tripwire/site-passphrase        password        
#tripwire        tripwire/site-passphrase-again  password        
#tripwire        tripwire/local-passphrase       password        
#tripwire        tripwire/use-sitekey    boolean true
#tripwire        tripwire/rebuild-config boolean true
#tripwire        tripwire/rebuild-policy boolean true
#apt-get -y install checksecurity lockfile-progs

# Firewall - TODO
# apt-get -y install shorewall nftables

# AppArmor/SELinux - TODO

# TLS and ciphers
# https://cipherli.st/
# http://disablessl3.com/
# https://poodle.io/servers.html
# https://www.sidorenko.io/blog/2014/02/13/secure-ssl-configuration-for-apache-postfix-dovecot/
# https://testssl.sh/
