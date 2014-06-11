package { 'puppet':
	ensure => installed,
}

service { 'puppet':
	ensure => running,
	enable => true,
}

include users
include environment
include ntp
include ssh
include snmp-agent

node "roteador" {

	include router
	include nginx
	include snmp-manager

}

node "openstack0" {

	package { 'puppetmaster':
		ensure => installed,
	}

	service { 'puppetmaster':
		ensure => running,
		enable => true,
	}

	include nvidia
	include dns
	include mysql
	include ceph-common
	include ceph-openstack0
	include openstack-common
	include openstack-rabbitmq
	include openstack-keystone
	include openstack-glance
	include openstack-nova-controller
	include openstack-neutron-controller
	include openstack-cinder-common
	include openstack-cinder-controller
	include openstack-horizon

}

node "openstack1" {

	include nvidia
	include ceph-common
	include ceph-openstack1
	include openstack-common
	include openstack-nova-compute
	include openstack-neutron-network-compute
	include openstack-cinder-common
	include openstack-cinder-node

}

node "openstack2" {

	include nvidia
	include ceph-common
	include ceph-openstack2
	include openstack-common
	include openstack-nova-compute
	include openstack-neutron-network-compute
	include openstack-cinder-common
	include openstack-cinder-node

}

