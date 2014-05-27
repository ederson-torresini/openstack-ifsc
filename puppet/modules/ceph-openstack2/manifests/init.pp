class ceph-openstack2 {

	# See http://ceph.com/docs/master/rados/operations/add-or-rm-mons/ how to create this file.
	file { 'mon.auth':
		path => '/etc/ceph/mon.auth',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-openstack2/mon.auth',
		owner => root,
		group => root,
		mode => 0600,
	}

	file { 'mon:ceph-openstack2':
		path => '/var/lib/ceph/mon/ceph-openstack2',
		ensure => directory,
		owner => root,
		group => root,
		mode => 0600,
	}

	exec { 'mon:fs':
		command => '/usr/bin/ceph-mon -i openstack2 --mkfs --monmap /etc/ceph/mon.map --keyring /etc/ceph/mon.auth',
		require => [
			File['mon.map'],
			File['mon.auth'],
			File['mon:ceph-openstack2'],
		],
		creates => '/var/lib/ceph/mon/ceph-openstack2/keyring',
	}

	exec { 'mon:add':
		command => '/usr/bin/ceph mon add openstack2 10.45.0.202:6789',
		subscribe => Exec['mon:fs'],
		refreshonly => true,
	}

	file { 'mon:done':
		path => '/var/lib/ceph/mon/ceph-openstack2/done',
		ensure => file,
		require => Exec['mon:fs'],
	}

	file { 'mon:upstart':
		path => '/var/lib/ceph/mon/ceph-openstack2/upstart',
		ensure => file,
		require => Exec['mon:fs'],
	}

}

