class openstack-neutron-controller {

	package { 'neutron-server':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'neutron-plugin-ml2':
		ensure => installed,
	}

	file { 'neutron.conf':
		path => '/etc/neutron/neutron.conf',
		ensure => file,
		require => Package['neutron-server'],
		source => 'puppet:///modules/openstack-neutron-controller/neutron.conf',
		owner => root,
		group => neutron,
		mode => 0640,
	}

	file { 'ml2_conf.ini':
		path => '/etc/neutron/plugins/ml2/ml2_conf.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-controller/ml2_conf.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-plugin-ml2'],
	}

	service { 'neutron-server':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['ml2_conf.ini'],
		],
	}

	file { '/var/lib/neutron/neutron.sqlite':
		ensure => absent,
	}

	file { '/etc/neutron/sql':
		ensure => directory,
		require => Package['neutron-server'],
		owner => root,
		group => neutron,
		mode => 0750,
	}

	file { 'neutron.sql':
		path => '/etc/neutron/sql/neutron.sql',
		ensure => file,
		require => File['/etc/neutron/sql'],
		source => 'puppet:///modules/openstack-neutron-controller/neutron.sql',
		owner => root,
		group => neutron,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -uroot < /etc/neutron/sql/neutron.sql':
		creates => '/var/lib/mysql/neutron',
		require => [
			File['neutron.sql'],
			Class['mysql'],
		],
	}

	file { 'neutron-init.sh':
		path => '/usr/local/sbin/neutron-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-controller/neutron-init.sh',
		owner => root,
		group => neutron,
		mode => 0750,
	}

	file { 'neutron.sh:link':
		path => '/etc/neutron/neutron-init.sh',
		ensure => link,
		target => '/usr/local/sbin/neutron-init.sh',
	}

	exec { '/usr/local/sbin/neutron-init.sh':
		subscribe => Exec['/usr/bin/mysql -uroot < /etc/neutron/sql/neutron.sql'],
		refreshonly => true,
	}

}

