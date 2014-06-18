class openstack-cinder-common {

	package { 'cinder-common':
		ensure => installed,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder how to create this file.
	file { 'ceph.client.cinder.keyring':
		path => '/etc/ceph/ceph.client.cinder.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder-common/ceph.client.cinder.keyring',
		owner => root,
		group => cinder,
		mode => 0644,
		require => [
			Package['ceph'],
			Package['cinder-common'],
		],
	}

	exec { 'ceph auth caps client.cinder':
		command => '/usr/bin/ceph auth caps client.cinder mon \'allow r\' osd \'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images\'',
		subscribe => File['ceph.client.cinder.keyring'],
		refreshonly => true,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder how to create this file.
	file { 'ceph.client.cinder-backup.keyring':
		path => '/etc/ceph/ceph.client.cinder-backup.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder-common/ceph.client.cinder-backup.keyring',
		owner => root,
		group => cinder,
		mode => 0644,
		require => [
			Package['ceph'],
			Package['cinder-common'],
		],
	}

	exec { 'ceph auth caps client.cinder-backup':
		command => '/usr/bin/ceph auth caps client.cinder-backup mon \'allow r\' osd \'allow class-read object_prefix rbd_children, allow rwx pool=backups\'',
		subscribe => File['ceph.client.cinder-backup.keyring'],
		refreshonly => true,
	}

	file { 'cinder.conf':
		path => '/etc/cinder/cinder.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder-common/cinder.conf',
		owner => root,
		group => cinder,
		mode => 0640,
	}

}

