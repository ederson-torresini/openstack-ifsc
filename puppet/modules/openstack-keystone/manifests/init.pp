class openstack-keystone {

	package { 'python-keystone':
		ensure => installed,
	}

	package { 'keystone':
		ensure => installed,
		require => Package['mysql-client'],
	}

	file { 'keystone.conf':
		path => '/etc/keystone/keystone.conf',
		source => 'puppet:///modules/openstack-keystone/keystone.conf',
		owner => root,
		group => keystone,
		mode => 0640,
		require => Package['keystone'],
	}

	service { 'keystone':
		ensure => running,
		enable => true,
		subscribe => File['keystone.conf'],
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

	exec { 'mysql -uroot -h mysql < /etc/keystone/sql/keystone.sql':
		path => '/usr/bin',
		require => File['keystone.sql'],
		unless => '/usr/bin/mysql -uroot -hmysql -e "show databases;"| /bin/grep -q keystone',
	}

	exec { '/usr/bin/keystone-manage db_sync':
		user => 'keystone',
		require => [
			Package['keystone'],
			Exec['mysql -uroot -h mysql < /etc/keystone/sql/keystone.sql'],
		],
		unless => '/usr/bin/mysql -uroot -hmysql -e "use keystone; show tables;"| /bin/grep -q user',
	}

	# Check http://docs.openstack.org/icehouse/install-guide/install/apt/content/keystone-users.html
	file { 'keystone-init.sh':
		path => '/usr/local/sbin/keystone-init.sh',
		source => 'puppet:///modules/openstack-keystone/keystone-init.sh',
		owner => root,
		group => keystone,
		mode => 0750,
		require => Package['keystone'],
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

	file { 'logrotate:keystone':
		path => '/etc/logrotate.d/keystone',
		source => 'puppet:///modules/openstack-keystone/logrotate',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['keystone'],
	}

}

class openstack-keystone::cleaning {

	schedule { 'daily':
		period => daily,
		repeat => 1,
	}

	exec { 'keystone-manage:token_flush':
		command => '/usr/bin/keystone-manage token_flush',
		schedule => daily,
		require => [
			Package['keystone'],
			Package['mysql-client'],
		],
	}

}
