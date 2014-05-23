class ceph-common {

	package { 'ceph':
		ensure => installed,
	}

	file { 'ceph.conf':
		path => '/etc/ceph/ceph.conf',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-common/ceph.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

    # See http://ceph.com/docs/master/install/manual-deployment/ how to create this file.
	file { 'ceph.client.admin.keyring':
		path => '/etc/ceph/ceph.client.admin.keyring',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-common/ceph.client.admin.keyring',
		owner => root,
		group => root,
		mode => 0600,
	}

	package { 'lvm2':
		ensure => installed,
	}

	exec { 'pvcreate /dev/sda3':
		path => '/sbin',
		creates => '/dev/openstack/ceph',
		require => Package['lvm2'],
	}

	exec { 'vgcreate openstack /dev/sda3':
		path => '/sbin',
		creates => '/dev/openstack/ceph',
		require => Exec['pvcreate /dev/sda3'],
	}

	exec { 'lvcreate -n ceph -L 800G openstack':
		path => '/sbin',
		creates => '/dev/openstack/ceph',
		require => Exec['vgcreate openstack /dev/sda3'],
	}

	package { 'xfsprogs':
		ensure => installed,
	}

	# Check modules/ceph-{node}...

}

