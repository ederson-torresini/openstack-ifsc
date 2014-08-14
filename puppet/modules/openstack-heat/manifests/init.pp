# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/heat-install.html
class openstack-heat {

	package { 'heat-api':
		ensure => installed,
	}
	
	package { 'heat-api-cfn':
		ensure => installed,
	}
	
	package { 'heat-engine':
		ensure => installed,
	}

	file { 'heat.conf':
		path => '/etc/heat/heat.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-heat/heat.conf',
		owner => root,
		group => heat,
		mode => 0640,
		require => [
			Package['heat-api'],
			Package['heat-api-cfn'],
			Package['heat-engine'],
		],
	}
	
	service { [
		'heat-api',
		'heat-api-cfn',
		'heat-engine',
	]:
		ensure => running,
		enable => true,
		subscribe => File['heat.conf'],
	}

	file { '/var/lib/heat/heat.sqlite':
		ensure => absent,
	}

	file { '/etc/heat/sql':
		ensure => directory,
		require => Package['heat-engine'],
		owner => root,
		group => heat,
		mode => 0750,
	}

	file { 'heat.sql':
		path => '/etc/heat/sql/heat.sql',
		ensure => file,
		source => 'puppet:///modules/openstack-heat/heat.sql',
		owner => root,
		group => heat,
		mode => 0640,
		require => File['/etc/heat/sql'],
	}

	exec { 'mysql heat.sql':
		command => '/usr/bin/mysql -uroot < /etc/heat/sql/heat.sql',
		creates => '/var/lib/mysql/heat',
		require => [
			File['heat.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/heat-manage db_sync':
		creates => '/var/lib/mysql/heat/tasks.frm',
		user => 'heat',
		require => [
			Package['heat-api'],
			Package['heat-api-cfn'],
			Package['heat-engine'],
			Exec['mysql heat.sql'],
		],
	}

	file { 'heat-init.sh':
		path => '/usr/local/sbin/heat-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-heat/heat-init.sh',
		owner => root,
		group => heat,
		mode => 0750,
	}

	file { 'heat.sh:link':
		path => '/etc/heat/heat-init.sh',
		ensure => link,
		target => '/usr/local/sbin/heat-init.sh',
	}

	exec { '/usr/local/sbin/heat-init.sh':
		require => Exec['/usr/local/sbin/keystone-init.sh'],
		subscribe => Exec['/usr/bin/heat-manage db_sync'],
		refreshonly => true,
	}

}
