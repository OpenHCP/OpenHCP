#!/bin/bash

if [ ! -e $SSLCERTPATH ]; then
	echo "There's no SSL certificate in \$SSLCERTPATH path ($SSLCERTPATH). Using SnakeOil one."
	ln -s ssl-cert-snakeoil.pem /etc/ssl/certs/openhcp.pem
fi

if [ ! -e $SSLKEYPATH ]; then
	echo "There's no SSL key in \$SSLKEYPATH path ($SSLKEYPATH). Using SnakeOil one."
	ln -s ssl-cert-snakeoil.key /etc/ssl/private/openhcp.key
fi

if [ ! -e "/etc/ssl/private/openhcp-bundle.pem" ]; then
	echo "There's no key+cert bundle - some daemons will need it that way. Creating one."
	cat /etc/ssl/private/openhcp.key /etc/ssl/certs/openhcp.pem > /etc/ssl/private/openhcp-bundle.pem
fi
