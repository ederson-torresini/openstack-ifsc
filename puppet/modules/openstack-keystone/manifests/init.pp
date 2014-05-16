class openstack-keystone {
	package { 'python-keystone':
		ensure => installed,
	}

	package { 'keystone':
		ensure => installed,
		before => File['keystone.conf'],
	}

	service { 'keystone':
		ensure => running,
		enable => true,
		subscribe => File['keystone.conf'],
	}

	file { 'keystone.conf':
		path => '/etc/keystone/keystone.conf',
		ensure => file,
		require => Package['keystone'],
		source => 'puppet:///modules/openstack-keystone/keystone.conf',
		owner => root,
		group => root,
		mode => 0644,
	}
}
