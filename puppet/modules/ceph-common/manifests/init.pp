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

}

