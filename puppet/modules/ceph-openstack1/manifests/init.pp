class ceph-openstack1 {

	exec { 'echo "/dev/openstack/ceph /var/lib/ceph/osd/ceph-1 xfs defaults,nofail 0 2" >> /etc/fstab':
		path => [
			'/bin',
		],
		unless => 'grep -q /dev/openstack/ceph /etc/fstab',
	}

	exec { 'mkfs -t xfs -f /dev/openstack/ceph':
		path => [
			'/bin',
			'/sbin',
		],
		require => [
			Package['xfsprogs'],
			Exec['lvcreate -n ceph -L 800G openstack'],
		],
		subscribe => Exec['echo "/dev/openstack/ceph /var/lib/ceph/osd/ceph-1 xfs defaults,nofail 0 2" >> /etc/fstab'],
		refreshonly => true,
	}

	# See http://ceph.com/docs/master/rados/operations/add-or-rm-mons/ how to create this file.
	file { 'mon.auth':
		path => '/etc/ceph/mon.auth',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-openstack1/mon.auth',
		owner => root,
		group => root,
		mode => 0600,
	}

	# See http://ceph.com/docs/master/rados/operations/add-or-rm-mons/ how to create this file.
	file { 'mon.map':
		path => '/etc/ceph/mon.map',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-openstack1/mon.map',
		owner => root,
		group => root,
		mode => 0600,
	}

	file { 'mon:ceph-openstack1':
		path => '/var/lib/ceph/mon/ceph-openstack1',
		ensure => directory,
		owner => root,
		group => root,
		mode => 0600,
	}

	exec { 'mon:fs':
		command => 'sudo ceph-mon -i openstack1 --mkfs --monmap /etc/ceph/mon.map --keyring /etc/ceph/mon.auth',
		path => '/usr/bin',
		require => [
			File['mon.map'],
			File['mon.auth'],
			File['mon:ceph-openstack1'],
		],
		creates => '/var/lib/ceph/mon/ceph-openstack1/keyring',
	}

	exec { 'mon:add':
		path => '/usr/bin',
		command => 'ceph mon add openstack1 10.45.0.201:6789',
		subscribe => Exec['mon:fs'],
		refreshonly => true,
	}

	file { 'mon:done':
		path => '/var/lib/ceph/mon/ceph-openstack1/done',
		ensure => file,
		require => Exec['mon:fs'],
	}

	file { 'mon:upstart':
		path => '/var/lib/ceph/mon/ceph-openstack1/upstart',
		ensure => file,
		require => File['mon:done'],
	}

	service { 'ceph-mon-all-starter':
		enable => true,
		ensure => running,
		require => [
			File['mon:upstart'],
		],
	}

}

