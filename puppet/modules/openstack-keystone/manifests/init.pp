class openstack-keystone {

	package { 'python-keystone':
		ensure => installed,
	}

	package { 'keystone':
		ensure => installed,
		before => File['keystone.conf'],
		require => Class['mysql'],
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

	file { '/etc/keystone/sql':
		ensure => directory,
		require => Package['keystone'],
		owner => root,
		group => keystone,
		mode => 0750,
	}

	file { 'keystone.sql':
		path => '/etc/keystone/sql/keystone.sql',
		ensure => file,
		require => File['/etc/keystone/sql'],
		source => 'puppet:///modules/openstack-keystone/keystone.sql',
		owner => root,
		group => keystone,
		mode => 0640,
	}

	exec { 'mysql -uroot < /etc/keystone/sql/keystone.sql':
		path => '/usr/bin',
		creates => '/var/lib/mysql/keystone',
		require => [
			File['keystone.sql'],
			Class['mysql'],
		],
	}

	exec { 'keystone-manage db_sync':
		path => '/usr/bin',
		creates => '/var/lib/mysql/keystone/user.frm',
		user => 'keystone',
		require => [
			Package['keystone'],
			Exec['mysql -uroot < /etc/keystone/sql/keystone.sql'],
		],
	}

}

