class openstack-nova-controller {

	package { 'nova-common':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
			
		],
	}

	package { 'nova-api':
		ensure => installed,
		require => Package['nova-common'],
	}

	package { 'nova-cert':
		ensure => installed,
		require => Package['nova-common'],
	}

	package { 'nova-conductor':
		ensure => installed,
		require => Package['nova-common'],
	}

	package { 'nova-consoleauth':
		ensure => installed,
		require => Package['nova-common'],
	}

	package { 'nova-novncproxy':
		ensure => installed,
		require => Package['nova-common'],
	}

	package { 'nova-scheduler':
		ensure => installed,
		require => Package['nova-common'],
	}

	service { 'nova-api':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	service { 'nova-cert':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	service { 'nova-conductor':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	service { 'nova-consoleauth':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	service { 'nova-novncproxy':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	service { 'nova-scheduler':
		ensure => running,
		enable => true,
		subscribe => File['nova.conf'],
	}

	file { 'nova.conf':
		path => '/etc/nova/nova.conf',
		ensure => file,
		require => Package['nova-common'],
		source => 'puppet:///modules/openstack-nova-controller/nova.conf',
		owner => root,
		group => nova,
		mode => 0640,
	}

	file { '/var/lib/nova/nova.sqlite':
		ensure => absent,
	}

	file { '/etc/nova/sql':
		ensure => directory,
		require => Package['nova-common'],
		owner => root,
		group => nova,
		mode => 0750,
	}

	file { 'nova.sql':
		path => '/etc/nova/sql/nova.sql',
		ensure => file,
		require => File['/etc/nova/sql'],
		source => 'puppet:///modules/openstack-nova-controller/nova.sql',
		owner => root,
		group => nova,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -uroot < /etc/nova/sql/nova.sql':
		creates => '/var/lib/mysql/nova',
		require => [
			File['nova.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/nova-manage db sync':
		creates => '/var/lib/mysql/nova/volumes.frm',
		user => 'nova',
		require => [
			Package['nova-common'],
			Exec['/usr/bin/mysql -uroot < /etc/nova/sql/nova.sql'],
		],
	}

	file { 'nova-init.sh':
		path => '/usr/local/sbin/nova-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-controller/nova-init.sh',
		owner => root,
		group => nova,
		mode => 0750,
	}

	file { 'nova.sh:link':
		path => '/etc/nova/nova-init.sh',
		ensure => link,
		target => '/usr/local/sbin/nova-init.sh',
	}

	exec { '/usr/local/sbin/nova-init.sh':
		subscribe => Exec['/usr/bin/nova-manage db sync'],
		refreshonly => true,
	}

}

