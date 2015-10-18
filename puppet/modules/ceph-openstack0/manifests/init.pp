class ceph-openstack0 {

	# See http://ceph.com/docs/master/install/manual-deployment/ how to create this file.
	file { 'ceph.mon.keyring':
		path => '/etc/ceph/ceph.mon.keyring',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-openstack0/ceph.mon.keyring',
		owner => root,
		group => root,
		mode => 0600,
	}

	file { 'mon:ceph-openstack0':
		path => '/var/lib/ceph/mon/ceph-openstack0',
		ensure => directory,
		owner => root,
		group => root,
		mode => 0600,
		require => Package['ceph'],
	}

	exec { 'mon:fs':
		command => '/usr/bin/ceph-mon --mkfs -i openstack0 --monmap /etc/ceph/mon.map --keyring /etc/ceph/ceph.mon.keyring',
		require => [
			File['mon.map'],
			File['ceph.mon.keyring'],
			File['mon:ceph-openstack0'],
		],
		creates => '/var/lib/ceph/mon/ceph-openstack0/keyring',
	}

	file { 'mon:done':
		path => '/var/lib/ceph/mon/ceph-openstack0/done',
		ensure => file,
		require => Exec['mon:fs'],
	}

	file { 'mon:upstart':
		path => '/var/lib/ceph/mon/ceph-openstack0/upstart',
		ensure => file,
		require => Exec['mon:fs'],
	}

}
