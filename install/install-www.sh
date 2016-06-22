#!/bin/bash

# Apache + PHP
apt-get -y install apache2 php5-fpm php5-apcu php5-igbinary php5-geoip php5-mysqlnd php5-recode php5-tidy php5-twig php5-curl php5-gd php5-imagick php5-imap php5-intl php5-mcrypt php5-pspell php5-sqlite php5-xmlrpc php5-xsl

a2enmod rewrite ssl actions include proxy_fcgi headers access_compat

mv /var/www/html /var/www/html.`date +'%Y%m%d%H%M%S'`

# security
TMPAPACHE=`mktemp`
cat /etc/apache2/conf-available/security.conf | sed -e 's/ServerTokens OS/ServerTokens Prod/' | sed -e 's/ServerSignature On/ServerSignature Off/' > $TMPAPACHE
mv -f $TMPAPACHE /etc/apache2/conf-available/security.conf
chmod 644 /etc/apache2/conf-available/security.conf

mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.`date +'%Y%m%d%H%M%S'`
cp php5-fpm/openhcp.conf /etc/php5/fpm/pool.d/

# PHP
PHPTMP=`mktemp`
PHPTZ=`cat /etc/timezone`
cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.`date +'%Y%m%d%H%M%S'`
cat /etc/php5/fpm/php.ini | \
	sed -e "s/;date.timezone =/date.timezone = $(echo $PHPTZ | sed -e 's/[/]/\\&/g')/" | \
	sed -e 's/expose_php = On/expose_php = Off/' | \
	sed -e 's/; max_input_vars = 1000/max_input_vars = 10000/' | \
	sed -e 's/;openssl.capath=/openssl.capath = \/etc\/ssl\/certs/' > $PHPTMP
cat $PHPTMP > /etc/php5/fpm/php.ini
cp /etc/php5/cli/php.ini /etc/php5/cli/php.ini.`date +'%Y%m%d%H%M%S'`
cat /etc/php5/cli/php.ini | \
	sed -e "s/;date.timezone =/date.timezone = $(echo $PHPTZ | sed -e 's/[/]/\\&/g')/" | \
	sed -e 's/expose_php = On/expose_php = Off/' | \
	sed -e 's/; max_input_vars = 1000/max_input_vars = 10000/' | \
	sed -e 's/;openssl.capath=/openssl.capath = \/etc\/ssl\/certs/' > $PHPTMP
cat $PHPTMP > /etc/php5/cli/php.ini
rm $PHPTMP

# install ionCube
#wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
IONDIR=`mktemp -d`
tar -xzf ioncube_loaders_lin_x86-64.tar.gz -C ${IONDIR}
mkdir -p /opt/ioncube/
cp ${IONDIR}/ioncube/ioncube_loader_lin_5.6.so /opt/ioncube/
echo "zend_extension=/opt/ioncube/ioncube_loader_lin_5.6.so" > /etc/php5/mods-available/ioncube.ini
ln -s /etc/php5/mods-available/ioncube.ini /etc/php5/fpm/conf.d/00-ioncube.ini
ln -s /etc/php5/mods-available/ioncube.ini /etc/php5/cli/conf.d/00-ioncube.ini
rm -fr $IONDIR

# prepare chroot
mkdir -p /var/openhcp/openhcp/www/api/www /var/openhcp/openhcp/www/api/etc /var/openhcp/openhcp/www/api/usr/share /var/openhcp/openhcp/www/api/dev /var/openhcp/openhcp/www/api/lib /var/openhcp/openhcp/www/api/var/run/mysqld/
chown openhcp.openhcp /var/openhcp/openhcp/www/api/www
cp -a /etc/host.conf /etc/hosts /etc/localtime /etc/resolv.conf /var/openhcp/openhcp/www/api/etc/
cp -a -r /usr/share/zoneinfo /var/openhcp/openhcp/www/api/usr/share/
cp -a /dev/*random /dev/zero /dev/null /var/openhcp/openhcp/www/api/dev/
cp -a /lib/x86_64-linux-gnu/libnss_dns*.so* /var/openhcp/openhcp/www/api/lib/
# MySQL via socket in chroot :)
# TODO - put it in /etc/fstab
mount -o bind /run/mysqld/ /var/openhcp/openhcp/www/api/var/run/mysqld/

wget http://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types -O /var/openhcp/openhcp/www/api/etc/mime.types
cp apache/openhcp.conf /etc/apache2/sites-available/
a2dissite 000-default
a2ensite openhcp

service php5-fpm restart
service apache2 restart
