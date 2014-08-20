# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/trove-install.html
class openstack-trove {

	package { 'trove-common':
		ensure => installed,
	}
	
	package { 'trove-api':
		ensure => installed,
	}
	
	package { 'trove-taskmanager':
		ensure => installed,
	}

	file { '/etc/trove/sql':
		ensure => directory,
		owner => root,
		group => trove,
		mode => 0750,
		require => Package['trove-common'],
	}

	file { 'trove.sql':
		path => '/etc/trove/sql/trove.sql',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/trove.sql',
		owner => root,
		group => trove,
		mode => 0640,
		require => File['/etc/trove/sql'],
	}

	exec { 'mysql trove.sql':
		command => '/usr/bin/mysql -uroot < /etc/trove/sql/trove.sql',
		creates => '/var/lib/mysql/trove',
		require => [
			File['trove.sql'],
			Class['mysql'],
		],
	}

	exec { 'trove-manage db_sync':
		command => '/usr/bin/trove-manage db_sync',
		creates => '/var/lib/mysql/trove/datastores.frm',
		user => 'trove',
		require => [
			Package['trove-common'],
			Exec['mysql trove.sql'],
		],
	}

	exec { 'trove-manage datastore_update mysql':
		command => "/usr/bin/trove-manage datastore_update mysql ''",
		user => 'trove',
		require => Exec['trove-manage db_sync'],
		refreshonly => true,
	}

	file { 'trove-init.sh':
		path => '/usr/local/sbin/trove-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/trove-init.sh',
		owner => root,
		group => trove,
		mode => 0750,
	}

	file { 'trove.sh:link':
		path => '/etc/trove/trove-init.sh',
		ensure => link,
		target => '/usr/local/sbin/trove-init.sh',
	}

	exec { 'trove-init.sh':
		command => '/usr/local/sbin/trove-init.sh',
		require => Exec['/usr/local/sbin/keystone-init.sh'],
		subscribe => Exec['trove-manage db_sync'],
		refreshonly => true,
	}

	file { '/var/cache/trove':
		ensure => directory,
		owner => root,
		group => trove,
		mode => 0770,
	}

	file { 'trove:api-paste.ini':
		path => '/etc/trove/api-paste.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/api-paste.ini',
		owner => root,
		group => trove,
		mode => 0640,
		require => [
			Package['trove-api'],
			File['/var/cache/trove'],
		],
	}

	file { 'trove.conf':
		path => '/etc/trove/trove.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/trove.conf',
		owner => root,
		group => trove,
		mode => 0640,
		require => Package['trove-api'],
	}
	
	file { 'trove-taskmanager.conf':
		path => '/etc/trove/trove-taskmanager.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/trove-taskmanager.conf',
		owner => root,
		group => trove,
		mode => 0640,
		require => Package['trove-taskmanager'],
	}
	
	file { 'trove-conductor.conf':
		path => '/etc/trove/trove-conductor.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-trove/trove-conductor.conf',
		owner => root,
		group => trove,
		mode => 0640,
		require => Package['trove-api'],
	}
	
	service { 'trove-api':
		ensure => running,
		enable => true,
		subscribe => [
			File['trove:api-paste.ini'],
			File['trove.conf'],
		],
	}
	
	service { 'trove-taskmanager':
		ensure => running,
		enable => true,
		subscribe => File['trove-taskmanager.conf'],
	}
	
#	service { 'trove-conductor':
#		ensure => running,
#		enable => true,
#		subscribe => File['trove-conductor.conf'],
#	}

}
