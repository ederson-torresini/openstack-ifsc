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
		path => '/etc/apache2/sites-available/horizon.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-horizon/apache2.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['apache2'],
	}

	exec { 'a2ensite horizon':
		command => '/usr/sbin/a2ensite horizon',
		creates => '/etc/apache2/sites-enabled/horizon.conf',
		require => File['apache2.conf'],
	}

	exec { 'a2dissite 000-default':
		command => '/usr/sbin/a2dissite 000-default',
		subscribe => Exec['a2ensite horizon'],
		refreshonly => true,
	}

	service { 'apache2':
		ensure => running,
		enable => true,
		subscribe => [
			File['local_settings.py'],
			File['memcached.conf'],
			File['apache2.conf'],
			Exec['a2dissite 000-default'],
			Exec['a2ensite horizon'],
			#
			# Based on https://ceph.com/docs/master/radosgw/config/#create-a-gateway-configuration
			Exec['a2ensite radosgw'],
		],
	}

}

