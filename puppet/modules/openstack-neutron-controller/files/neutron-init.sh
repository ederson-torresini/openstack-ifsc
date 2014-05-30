#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/neutron-ml2-controller-node.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone:35357/v2.0

keystone user-create --name neutron --pass neutron --email neutron@openstack.sj.ifsc.edu.br
keystone user-role-add --user neutron --tenant service --role admin

keystone service-create --name neutron --type network --description "OpenStack Networking"
keystone endpoint-create --region IFSC-SJ --service-id $(keystone service-list | awk '/ network / {print $2}') --publicurl http://neutron-controller:9696 --adminurl http://neutron-controller:9696 --internalurl http://neutron-controller:9696

