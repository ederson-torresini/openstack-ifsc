#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/cinder-controller.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone:35357/v2.0

keystone user-create --name cinder --pass cinder --email cinder@openstack.sj.ifsc.edu.br
keystone user-role-add --user cinder --tenant service --role admin

keystone service-create --name=cinder --type=volume --description="OpenStack Block Storage"
keystone endpoint-create --region IFSC-SJ --service-id=$(keystone service-list | awk '/ volume / {print $2}')  --publicurl=http://cinder-controller:8776/v1/%\(tenant_id\)s  --internalurl=http://cinder-controller:8776/v1/%\(tenant_id\)s  --adminurl=http://cinder-controller:8776/v1/%\(tenant_id\)s

keystone service-create --name=cinderv2 --type=volumev2 --description="OpenStack Block Storage v2"
keystone endpoint-create --region IFSC-SJ --service-id=$(keystone service-list | awk '/ volumev2 / {print $2}')  --publicurl=http://cinder-controller:8776/v2/%\(tenant_id\)s  --internalurl=http://cinder-controller:8776/v2/%\(tenant_id\)s  --adminurl=http://cinder-controller:8776/v2/%\(tenant_id\)s

