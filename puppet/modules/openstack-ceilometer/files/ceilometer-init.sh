#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/ceilometer-install.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone.openstack.sj.ifsc.edu.br:35357/v2.0

keystone user-create --name=ceilometer --pass=ceilometer --email=ceilometer@openstack.sj.ifsc.edu.br
keystone user-role-add --user=ceilometer --tenant=service --role=admin

keystone service-create --name=ceilometer --type=metering --description="Telemetry"
keystone endpoint-create --region=ifsc-sj --service-id=$(keystone service-list | awk '/ metering / {print $2}') --publicurl=http://ceilometer.openstack.sj.ifsc.edu.br:8777 --internalurl=http://ceilometer.openstack.sj.ifsc.edu.br:8777 --adminurl=http://ceilometer.openstack.sj.ifsc.edu.br:8777

# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/ceilometer-install-swift.html
keystone role-create --name=ResellerAdmin
keystone user-role-add --tenant service --user ceilometer --role ResellerAdmin
