#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/keystone-users.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone:35357/v2.0

keystone user-create --name=admin --pass=keystone --email=admin@openstack.sj.ifsc.edu.br
keystone role-create --name=admin
keystone tenant-create --name=admin --description="Admin Tenant"
keystone user-role-add --user=admin --tenant=admin --role=admin
keystone user-role-add --user=admin --role=_member_ --tenant=admin

keystone tenant-create --name=service --description="Service Tenant"
keystone service-create --name=keystone --type=identity --description="OpenStack Identity"
keystone endpoint-create --region=IFSC-SJ --service-id=$(keystone service-list | awk '/ identity / {print $2}') --publicurl=http://keystone:5000/v2.0 --internalurl=http://keystone:5000/v2.0 --adminurl=http://keystone:35357/v2.0

