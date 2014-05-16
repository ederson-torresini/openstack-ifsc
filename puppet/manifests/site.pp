# Drivers
include nvidia

# System
include users
include environment

# Basic services
include ntp
include ssh

# Clients
class { 'ldap':
	uri  => 'ldap://ldap',
	base => 'dc=openstack,dc=sj,dc=ifsc,dc=edu,dc=br',
}

include openstack-common

# Management
include snmp

node "openstack0"
{
	include dns

	package { 'puppetmaster':
		ensure => installed,
	}

	service { 'puppetmaster':
		ensure => running,
		enable => true,
	}

	exec { 'puppet module install torian-ldap':
		path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
		creates => '/etc/puppet/modules/ldap',
	}

	include mysql
	include openstack-rabbitmq
	include openstack-keystone
}

node "openstack1", "openstack2"
{
	package { 'puppet':
		ensure => installed,
	}

	service { 'puppet':
		ensure => running,
		enable => true,
	}
}

