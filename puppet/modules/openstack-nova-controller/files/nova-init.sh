#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-controller.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone:35357/v2.0

keystone user-create --name=nova --pass=nova --email=nova@openstack.sj.ifsc.edu.br
keystone user-role-add --user=nova --tenant=service --role=admin

keystone service-create --name=nova --type=compute --description="OpenStack Compute"
keystone endpoint-create --region=ifsc-sj --service-id=$(keystone service-list | awk '/ compute / {print $2}') --publicurl=http://nova-controller:8774/v2/%\(tenant_id\)s --internalurl=http://nova-controller:8774/v2/%\(tenant_id\)s --adminurl=http://nova-controller:8774/v2/%\(tenant_id\)s
