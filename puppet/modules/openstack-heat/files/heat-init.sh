#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/heat-install.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone.openstack.sj.ifsc.edu.br:35357/v2.0

keystone user-create --name=heat --pass=heat --email=heat@openstack.sj.ifsc.edu.br
keystone user-role-add --user=heat --tenant=service --role=admin
keystone role-create --name heat_stack_user

keystone service-create --name=heat --type=orchestration --description="Orchestration"
keystone endpoint-create --region=ifsc-sj --service-id=$(keystone service-list | awk '/ orchestration / {print $2}') --publicurl=http://heat.openstack.sj.ifsc.edu.br:8004/v1/%\(tenant_id\)s --internalurl=http://heat.openstack.sj.ifsc.edu.br:8004/v1/%\(tenant_id\)s --adminurl=http://heat.openstack.sj.ifsc.edu.br:8004/v1/%\(tenant_id\)s
keystone service-create --name=heat-cfn --type=cloudformation --description="Orchestration CloudFormation"
keystone endpoint-create --region=ifsc-sj --service-id=$(keystone service-list | awk '/ cloudformation / {print $2}') --publicurl=http://heat.openstack.sj.ifsc.edu.br:8000/v1 --internalurl=http://heat.openstack.sj.ifsc.edu.br:8000/v1 --adminurl=http://heat.openstack.sj.ifsc.edu.br:8000/v1
