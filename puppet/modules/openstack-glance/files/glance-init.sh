#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/glance-install.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone:35357/v2.0

keystone user-create --name=glance --pass=glance --email=glance@openstack.sj.ifsc.edu.br
keystone user-role-add --user=glance --tenant=service --role=admin

keystone service-create --name=glance --type=image --description="OpenStack Image Service"
keystone endpoint-create --region=IFSC-SJ --service-id=$(keystone service-list | awk '/ image / {print $2}') --publicurl=http://glance:9292 --internalurl=http://glance:9292 --adminurl=http://glance:9292
