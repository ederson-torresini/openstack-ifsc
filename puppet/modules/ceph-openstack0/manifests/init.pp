class ceph-openstack0 {

	exec { 'echo "/dev/openstack/ceph /var/lib/ceph/osd/ceph-0 xfs defaults,nofail 0 2" >> /etc/fstab':
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
		subscribe => Exec['echo "/dev/openstack/ceph /var/lib/ceph/osd/ceph-0 xfs defaults,nofail 0 2" >> /etc/fstab'],
		refreshonly => true,
	}

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

	# See http://ceph.com/docs/master/install/manual-deployment/ how to create this file.
	file { 'monmap':
		path => '/etc/ceph/monmap',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-openstack0/monmap',
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
	}

	exec { 'mon:fs':
		command => 'ceph-mon --mkfs -i openstack0 --monmap /etc/ceph/monmap --keyring /etc/ceph/ceph.mon.keyring',
		path => '/usr/bin',
		require => [
			File['monmap'],
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

