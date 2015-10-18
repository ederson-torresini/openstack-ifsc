#!/bin/bash
#
# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/neutron-ml2-controller-node.html

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone.openstack.sj.ifsc.edu.br:35357/v2.0

keystone user-create --name neutron --pass neutron --email neutron@openstack.sj.ifsc.edu.br
keystone user-role-add --user neutron --tenant service --role admin

keystone service-create --name neutron --type network --description "OpenStack Networking"
keystone endpoint-create --region ifsc-sj --service-id $(keystone service-list | awk '/ network / {print $2}') --publicurl http://neutron-controller.openstack.sj.ifsc.edu.br:9696 --adminurl http://neutron-controller.openstack.sj.ifsc.edu.br:9696 --internalurl http://neutron-controller.openstack.sj.ifsc.edu.br:9696

# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/neutron_initial-external-network.html to create initial networks
neutron net-create ext-net --shared --router:external=True
neutron subnet-create ext-net --name ext-subnet --allocation-pool start=200.135.233.1,end=200.135.233.99 --disable-dhcp --gateway 200.135.233.126 200.135.233.0/25
