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

	# See http://ceph.com/docs/master/install/manual-deployment/ how to create this file.
	file { 'mon.map':
		path => '/etc/ceph/mon.map',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-common/mon.map',
		owner => root,
		group => root,
		mode => 0600,
	}

	package { 'lvm2':
		ensure => installed,
	}

	exec { '/sbin/pvcreate /dev/sda3':
		creates => '/dev/openstack/ceph',
		require => Package['lvm2'],
	}

	exec { '/sbin/vgcreate openstack /dev/sda3':
		creates => '/dev/openstack/ceph',
		require => Exec['/sbin/pvcreate /dev/sda3'],
	}

	exec { '/sbin/lvcreate -n ceph -L 800G openstack':
		creates => '/dev/openstack/ceph',
		require => Exec['/sbin/vgcreate openstack /dev/sda3'],
	}

	package { 'xfsprogs':
		ensure => installed,
	}

	# Check modules/ceph-{node}...

	service { 'ceph-mon-all-starter':
		enable => true,
		ensure => running,
		require => [
			File['mon:done'],
			File['mon:upstart'],
		],
	}

	file { 'osd-init.sh':
		path => '/usr/local/sbin/osd-init.sh',
		ensure => file,
		source => 'puppet:///modules/ceph-common/osd-init.sh',
		owner => root,
		group => root,
		mode => 0700,
	}

	file { 'osd-init.sh:link':
		path => '/etc/ceph/osd-init.sh',
		ensure => link,
		target => '/usr/local/sbin/osd-init.sh',
		require => File['osd-init.sh'],
	}

	exec { '/usr/local/sbin/osd-init.sh':
		require => File['osd-init.sh'],
		unless => '/bin/grep -q /dev/openstack/ceph /etc/fstab',
	}

	service { 'ceph-osd-all-starter':
		enable => true,
		ensure => running,
		require => Exec['/usr/local/sbin/osd-init.sh'],
	}

}

