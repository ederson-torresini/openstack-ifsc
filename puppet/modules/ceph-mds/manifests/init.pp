# Based on http://www.sebastien-han.fr/blog/2013/05/13/deploy-a-ceph-mds-server/

class ceph-mds {

	package { 'ceph-mds':
		ensure => installed,
	}

	file { 'ceph.mds.keyring':
		path => '/etc/ceph/ceph.mds.keyring',
		ensure => file,
		source => 'puppet:///modules/ceph-mds/ceph.mds.keyring',
		owner => root,
		group => root,
		mode => 0600,
		require => Package['ceph'],
	}

	exec { 'ceph auth caps mds':
		command => '/usr/bin/ceph auth caps mds.0 mds \'allow\' mon \'allow rwx\' osd \'allow *\'',
		subscribe => File['ceph.mds.keyring'],
		refreshonly => true,
	}

	file { 'ceph-0':
		path => '/var/lib/ceph/mds/ceph-0',
		ensure => directory,
		owner => root,
		group => root,
		mode => 0700,
	}

	file { 'done':
		path => '/var/lib/ceph/mds/ceph-0/done',
		ensure => file,
		owner => root,
		group => root,
		mode => 0600,
		require => File['ceph-0'],
	}

	file { 'upstart':
		path => '/var/lib/ceph/mds/ceph-0/upstart',
		ensure => file,
		owner => root,
		group => root,
		mode => 0600,
		require => File['ceph-0'],
	}

	service { 'ceph-mds-all-starter':
		enable => true,
		ensure => running,
		subscribe => File['ceph.mds.keyring'],
		require => [
			File['done'],
			File['upstart'],
		],
	}

	# Check https://ceph.com/docs/master/rados/operations/control/ how to create a pool and parameters.
	exec { 'pool compute':
		command => '/usr/bin/ceph osd pool create compute 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q compute',
		require => Package['ceph'],
	}

	exec { 'size compute':
		command => '/usr/bin/ceph osd pool set compute size 2',
		subscribe => Exec['pool compute'],
		refreshonly => true,
	}

	exec { 'pg_num compute':
		command => '/usr/bin/ceph osd pool set compute pg_num 128',
		subscribe => Exec['pool compute'],
		refreshonly => true,
	}

	exec { 'pgp_num compute':
		command => '/usr/bin/ceph osd pool set compute pgp_num 128',
		subscribe => Exec['pool compute'],
		refreshonly => true,
	}

	exec { 'add_data_pool':
		command => '/usr/bin/ceph mds add_data_pool compute',
		subscribe => Exec['pool compute'],
		refreshonly => true,
	}

}

