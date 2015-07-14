#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/trove-install.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone.openstack.sj.ifsc.edu.br:35357/v2.0

keystone user-create --name=trove --pass=trove --email=trove@openstack.sj.ifsc.edu.br
keystone user-role-add --user=trove --tenant=service --role=admin

keystone service-create --name=trove --type=database --description="OpenStack Database Service"
keystone endpoint-create --region=ifsc-sj --service-id=$(keystone service-list | awk '/ trove / {print $2}') --publicurl=http://trove.openstack.sj.ifsc.edu.br:8779/v1.0/%\(tenant_id\)s --internalurl=http://trove.openstack.sj.ifsc.edu.br:8779/v1.0/%\(tenant_id\)s --adminurl=http://trove.openstack.sj.ifsc.edu.br:8779/v1.0/%\(tenant_id\)s
