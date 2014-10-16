class openstack-neutron-controller inherits openstack-neutron::common {

	package { 'neutron-server':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	File <| title == 'neutron.conf' |> {
		require => Package['neutron-server'],
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
