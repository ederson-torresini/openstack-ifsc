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
include smtp
include ssh
include haproxy
include snmp-agent

node "roteador" {

	include router
	include nginx

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
	include syslog-server
	include mysql
	include ceph-common
	include ceph-openstack0
	include ceph-osd-init
	include ceph-mds
	include ceph-fs
	include ceph-radosgw
	include openstack-common
	include openstack-rabbitmq
	include openstack-keystone
	include openstack-glance
	include openstack-nova-controller
	include openstack-nova-compute::kvm
	include openstack-neutron-controller
	include openstack-neutron-agent::compute
	include openstack-neutron-agent::network
	include openstack-cinder-common
	include openstack-cinder-controller
	include openstack-cinder-node
	#include openstack-trove
	include openstack-heat
	include openstack-horizon
	include openstack-ceilometer::controller
	include openstack-ceilometer::compute	
	include snmp-manager

}

node "openstack1" {

	include nvidia
	include syslog-client
	include ceph-common
	include ceph-openstack1
	include ceph-fs
	include openstack-common
	include openstack-nova-compute::kvm
	include openstack-neutron-agent::compute
	include openstack-neutron-agent::network
	include openstack-cinder-common
	include openstack-cinder-node
	include openstack-ceilometer::compute

}

node "openstack2" {

	include nvidia
	include syslog-client
	include ceph-common
	include ceph-openstack2
	include ceph-fs
	include openstack-common
	include openstack-nova-compute::kvm
	include openstack-neutron-agent::compute
	include openstack-neutron-agent::network
	include openstack-cinder-common
	include openstack-cinder-node
	include openstack-ceilometer::compute

}

node "openstack3" {

	include nvidia
	include syslog-client
	include ceph-common
	include ceph-openstack3
	include ceph-fs
	include openstack-common
	include openstack-nova-compute::kvm
	include openstack-neutron-agent::compute
	include openstack-neutron-agent::network
	include openstack-cinder-common
	include openstack-cinder-node
	include openstack-ceilometer::compute

}
