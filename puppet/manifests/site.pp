include nvidia
include users
include environment
include ntp
include ssh
include snmp
class { 'ldap':
	uri  => 'ldap://ldap',
	base => 'dc=openstack,dc=sj,dc=ifsc,dc=edu,dc=br',
}

node "openstack0"
{
	package { 'puppetmaster':
		ensure => installed,
	}
	service { 'puppetmaster':
		ensure => running,
		enable => true,
	}
	include dns
	exec { 'puppet module install torian-ldap':
		path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
		creates => '/etc/puppet/modules/ldap',
	}
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

