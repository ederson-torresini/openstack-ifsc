# Drivers
include nvidia

# System
include users
include environment

# Basic services
include ntp
include ssh

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

}

node "openstack1", "openstack2" {

	package { 'puppet':
		ensure => installed,
	}

	service { 'puppet':
		ensure => running,
		enable => true,
	}

}

