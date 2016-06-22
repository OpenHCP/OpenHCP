#!/bin/bash

# install quota
apt-get -y install quota quotatool
# fix /etc/fstab
cp /etc/fstab /etc/fstab.`date +'%Y%m%d%H%M%S'`
TMPFSTAB=`mktemp`
cat /etc/fstab | sed -e 's/usrquota,grpquota/usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv1/' > $TMPFSTAB
mv -f $TMPFSTAB /etc/fstab
chmod 644 /etc/fstab

for PARTITION in `mount | grep ext | grep quota | awk '{print $3}'`; do
	mount -o remount $PARTITION
done
quotacheck -avgum
quotaon -avgu

# set grace period to month
setquota -u -t 2678400 2678400 -a
setquota -g -t 2678400 2678400 -a
