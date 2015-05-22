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

	exec { '/usr/bin/mysql -u root -h mysql < /etc/glance/sql/glance.sql':
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
			Exec['/usr/bin/mysql -u root -h mysql < /etc/glance/sql/glance.sql'],
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
		subscribe => File['glance-init.sh'],
		refreshonly => true,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=glance how to create this file.
	file { 'ceph.client.glance.keyring':
		path => '/etc/ceph/ceph.client.glance.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-glance/ceph.client.glance.keyring',
		owner => root,
		group => glance,
		mode => 0644,
		require => Package['ceph'],
	}

	exec { 'ceph auth caps client.glance':
		command => '/usr/bin/ceph auth caps client.glance mon \'allow r\' osd \'allow class-read object_prefix rbd_children, allow rwx pool=images\'',
		subscribe => File['ceph.client.glance.keyring'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { 'pool images':
		command => '/usr/bin/ceph osd pool create images 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q images',
		require => Package['ceph'],
	}

	exec { 'size images':
		command => '/usr/bin/ceph osd pool set images size 3',
		subscribe => Exec['pool images'],
		refreshonly => true,
	}

	exec { 'pg_num images':
		command => '/usr/bin/ceph osd pool set images pg_num 128',
		subscribe => Exec['pool images'],
		refreshonly => true,
	}

	exec { 'pgp_num images':
		command => '/usr/bin/ceph osd pool set images pgp_num 128',
		subscribe => Exec['pool images'],
		refreshonly => true,
	}

}

