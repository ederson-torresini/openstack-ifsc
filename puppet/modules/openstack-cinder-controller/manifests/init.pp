class openstack-cinder-controller {

	package { 'cinder-api':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'cinder-scheduler':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'cinder-backup':
		ensure => installed,
		require => [
			Package['cinder-api'],
			Package['cinder-scheduler'],
		],
	}

	service { 'cinder-api':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	service { 'cinder-scheduler':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	service { 'cinder-backup':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	file { '/var/lib/cinder/cinder.sqlite':
		ensure => absent,
	}

	file { '/etc/cinder/sql':
		ensure => directory,
		require => Package['cinder-api'],
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sql':
		path => '/etc/cinder/sql/cinder.sql',
		ensure => file,
		require => File['/etc/cinder/sql'],
		source => 'puppet:///modules/openstack-cinder-controller/cinder.sql',
		owner => root,
		group => cinder,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -u root -h mysql < /etc/cinder/sql/cinder.sql':
		creates => '/var/lib/mysql/cinder',
		require => [
			File['cinder.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/cinder-manage db sync':
		creates => '/var/lib/mysql/cinder/volumes.frm',
		user => 'cinder',
		require => [
			Package['cinder-api'],
			Package['cinder-scheduler'],
			Exec['/usr/bin/mysql -u root -h mysql < /etc/cinder/sql/cinder.sql'],
		],
	}

	file { 'cinder-init.sh':
		path => '/usr/local/sbin/cinder-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder-controller/cinder-init.sh',
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sh:link':
		path => '/etc/cinder/cinder-init.sh',
		ensure => link,
		target => '/usr/local/sbin/cinder-init.sh',
	}

	exec { '/usr/local/sbin/cinder-init.sh':
		subscribe => Exec['/usr/bin/mysql -u root -h mysql < /etc/cinder/sql/cinder.sql'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { 'pool volumes':
		command => '/usr/bin/ceph osd pool create volumes 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q volumes',
		require => Package['ceph'],
	}

	exec { 'size volumes':
		command => '/usr/bin/ceph osd pool set volumes size 2',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	exec { 'pg_num volumes':
		command => '/usr/bin/ceph osd pool set volumes pg_num 128',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	exec { 'pgp_num volumes':
		command => '/usr/bin/ceph osd pool set volumes pgp_num 128',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { 'pool backups':
		command => '/usr/bin/ceph osd pool create backups 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q backups',
		require => Package['ceph'],
	}

	exec { 'size backups':
		command => '/usr/bin/ceph osd pool set backups size 3',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

	exec { 'pg_num backups':
		command => '/usr/bin/ceph osd pool set backups pg_num 128',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

	exec { 'pgp_num backups':
		command => '/usr/bin/ceph osd pool set backups pgp_num 128',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

}

