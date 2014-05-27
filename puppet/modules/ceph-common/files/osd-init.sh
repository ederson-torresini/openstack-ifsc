#!/bin/bash
#
# Based on http://ceph.com/docs/next/install/manual-deployment/#long-form

export PATH=/bin:/usr/bin:/sbin:/usr/sbin

# To ensure idempotency required by Puppet
if [ "$(pidof ceph-osd)" -neq "" ]
then
	exit 0
fi

# Get OSD number
OSD_ID=$(ceph osd create)
if [ "${ISD_ID}" 0 "" ]
then
	echo "Critical error: unable to connect to any monitor to obtain OSD number. Check /etc/ceph/ceph.conf file and if ceph-mon is running."
	exit 1
fi

# To avoid problem later
HOSTNAME=${hostname -s}
if [ "${HOSTNAME}" = "" ]
then
	echo "Critical error: hostname empty. Please set one."
	exit 2
fi

umount -f /var/lib/ceph/osd/ceph-${OSD_ID}
mkdir /var/lib/ceph/osd/ceph-${OSD_ID}
mkfs -t xfs -f /dev/openstack/ceph
mount /dev/openstack/ceph /var/lib/ceph/osd/ceph-${OSD_ID}

ceph-osd -i ${OSD_ID} --mkfs --mkkey
ceph auth add osd.${OSD_ID} osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-${OSD_ID}/keyring

ceph osd crush add-bucket ${HOSTNAME} host
ceph osd crush move ${HOSTNAME} root=default
ceph osd crush add osd.${OSD_ID} 1.0 host=${HOSTNAME}

touch /var/lib/ceph/osd/ceph-${OSD_ID}/done
touch /var/lib/ceph/osd/ceph-${OSD_ID}/upstart
grep -q /dev/openstack/ceph /etc/fstab || echo "/dev/openstack/ceph /var/lib/ceph/osd/ceph-${OSD_ID} xfs defaults,nofail 0 2" >> /etc/fstab

