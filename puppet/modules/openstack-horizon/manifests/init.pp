class openstack-horizon {

	package { 'apache2':
		ensure => installed,
	}

	package { 'python-memcache':
		ensure => installed,
	}

	package { 'memcached':
		ensure => installed,
	}

	package { 'libapache2-mod-wsgi':
		ensure => installed,
	}

	package { 'openstack-dashboard':
		ensure => installed,
	}

	package { 'openstack-dashboard-ubuntu-theme':
		ensure => absent,
	}

	file { 'local_settings.py':
		path => '/etc/openstack-dashboard/local_settings.py',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/local_settings.py',
		owner => root,
		group => horizon,
		mode =>	0640,
		require => [
			Package['python-memcache'],
			Package['openstack-dashboard'],
		],
	}

	file { 'memcached.conf':
		path => '/etc/memcached.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/memcached.conf',
		owner => root,
		group => memcache,
		mode => 0640,
		require => Package['memcached'],
	}

	service { 'memcached':
		ensure => running,
		enable => true,
		subscribe => File['memcached.conf'],
	}

	file { 'apache2.conf':
		path => '/etc/apache2/conf-available/horizon.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/apache2.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['apache2'],
	}

	exec { 'conf-enable':
		command => '/usr/sbin/a2enconf horizon',
		creates => '/etc/apache2/conf-enabled/horizon',
		require => File['apache2.conf'],
	}

	service { 'apache2':
		ensure => running,
		enable => true,
		subscribe => [
			File['local_settings.py'],
			File['memcached.conf'],
			File['apache2.conf'],
		],
	}

}

