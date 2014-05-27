class openstack-keystone {

	package { 'python-keystone':
		ensure => installed,
	}

	package { 'keystone':
		ensure => installed,
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
		group => keystone,
		mode => 0640,
	}

	file { '/var/lib/keystone/keystone.db':
		ensure => absent,
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

	exec { '/usr/bin/keystone-manage db_sync':
		creates => '/var/lib/mysql/keystone/user.frm',
		user => 'keystone',
		require => [
			Package['keystone'],
			Exec['mysql -uroot < /etc/keystone/sql/keystone.sql'],
		],
	}

	# Check http://docs.openstack.org/icehouse/install-guide/install/apt/content/keystone-users.html
	file { 'keystone-init.sh':
		path => '/usr/local/sbin/keystone-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-keystone/keystone-init.sh',
		owner => root,
		group => keystone,
		mode => 0750,
	}

	file { 'keystone.sh:link':
		path => '/etc/keystone/keystone-init.sh',
		ensure => link,
		target => '/usr/local/sbin/keystone-init.sh',
	}

	exec { '/usr/local/sbin/keystone-init.sh':
		subscribe => Exec['/usr/bin/keystone-manage db_sync'],
		refreshonly => true,
	}

}

