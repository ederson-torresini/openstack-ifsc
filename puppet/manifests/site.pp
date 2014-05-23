# Puppet Agent
package { 'puppet':
	ensure => installed,
}

service { 'puppet':
	ensure => running,
	enable => true,
}

# Drivers
include nvidia

# System
include users
include environment

# Basic services
include ntp
include ssh

# Ceph
include ceph-common

# OpenStack
include openstack-common

# Management
include snmp

node "openstack0" {

	include dns

	package { 'puppetmaster':
		ensure => installed,
	}

	service { 'puppetmaster':
		ensure => running,
		enable => true,
	}

	include mysql
	include openstack-rabbitmq
	include openstack-keystone
	include ceph-openstack0

}

node "openstack1" {

	include ceph-openstack1

}

node "openstack2" {

	include ceph-openstack2

}

