class openstack-glance {

	package { 'python-glance':
		ensure => installed,
	}

	package { 'glance':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['ceph-common'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	service { 'glance-api':
		ensure => running,
		enable => true,
		subscribe => File['glance-api.conf'],
	}

	file { 'glance-api.conf':
		path => '/etc/glance/glance-api.conf',
		ensure => file,
		require => Package['glance'],
		source => 'puppet:///modules/openstack-glance/glance-api.conf',
		owner => root,
		group => glance,
		mode => 0640,
	}

	service { 'glance-registry':
		ensure => running,
		enable => true,
		subscribe => File['glance-registry.conf'],
	}

	file { 'glance-registry.conf':
		path => '/etc/glance/glance-registry.conf',
		ensure => file,
		require => Package['glance'],
		source => 'puppet:///modules/openstack-glance/glance-registry.conf',
		owner => root,
		group => glance,
		mode => 0640,
	}

	file { '/var/lib/glance/glance.sqlite':
		ensure => absent,
	}

	file { '/etc/glance/sql':
		ensure => directory,
		require => Package['glance'],
		owner => root,
		group => glance,
		mode => 0750,
	}

	file { 'glance.sql':
		path => '/etc/glance/sql/glance.sql',
		ensure => file,
		require => File['/etc/glance/sql'],
		source => 'puppet:///modules/openstack-glance/glance.sql',
		owner => root,
		group => glance,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -uroot < /etc/glance/sql/glance.sql':
		creates => '/var/lib/mysql/glance',
		require => [
			File['glance.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/glance-manage db_sync':
		creates => '/var/lib/mysql/glance/tasks.frm',
		user => 'glance',
		require => [
			Package['glance'],
			Exec['/usr/bin/mysql -uroot < /etc/glance/sql/glance.sql'],
		],
	}

	# Check http://docs.openstack.org/icehouse/install-guide/install/apt/content/glance-install.html
	file { 'glance-init.sh':
		path => '/usr/local/sbin/glance-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-glance/glance-init.sh',
		owner => root,
		group => glance,
		mode => 0750,
	}

	file { 'glance.sh:link':
		path => '/etc/glance/glance-init.sh',
		ensure => link,
		target => '/usr/local/sbin/glance-init.sh',
	}

	exec { '/usr/local/sbin/glance-init.sh':
		require => Exec['/usr/local/sbin/keystone-init.sh'],
		subscribe => Exec['/usr/bin/glance-manage db_sync'],
		refreshonly => true,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=glance how to create this file.
	file { 'ceph.client.glance.keyring':
		path => '/etc/ceph/ceph.client.glance.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-glance/ceph.client.glance.keyring',
		owner => root,
		group => glance,
		mode => 0640,
		require => Package['ceph'],
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { '/usr/bin/ceph osd pool create images 128':
		require => Package['ceph'],
		subscribe => Exec['/usr/local/sbin/glance-init.sh'],
		refreshonly => true,
	}

}

