# Based on http://docs.openstack.org/trunk/config-reference/content/configuring-openstack-compute-basics.html

class ceph-fs {

	file { 'client.cephfs.keyring':
		path => '/etc/ceph/client.cephfs.keyring',
		ensure => file,
		source => 'puppet:///modules/ceph-fs/client.cephfs.keyring',
		owner => root,
		group => root,
		mode => 0600,
		require => Package['ceph'],
	}

	file { 'client.cephfs.secret':
		path => '/etc/ceph/client.cephfs.secret',
		ensure => file,
		source => 'puppet:///modules/ceph-fs/client.cephfs.secret',
		owner => root,
		group => root,
		mode => 0600,
		require => Package['ceph'],
	}

	exec { 'client.cephfs':
		command => '/usr/bin/ceph auth caps client.cephfs  msd "allow" mon "allow r" osd "allow class-read object_prefix rbd_children, allow rwx pool=compute"',
		subscribe => File['client.cephfs.keyring'],
		refreshonly => true,
		require => Package['ceph'],
	}

	exec { 'fstab:ceph':
		command => "/bin/echo openstack0,openstack1,openstack2:/ /var/lib/nova/instances ceph name=cephfs,secretfile=/etc/ceph/client.cephfs.secret,noatime 0 0 >> /etc/fstab",
		unless => '/bin/grep -q /var/lib/nova/instances /etc/fstab',
	}

	exec { 'mount':
		command => '/bin/mount -a -t ceph',
		subscribe => Exec['fstab:ceph'],
		refreshonly => true,
		require => Package['ceph'],
	}

	exec { 'set_layout':
		command => '/usr/bin/cephfs /var/lib/nova/instances/ set_layout -p $(ceph osd dump|grep compute|cut -d \  -f 2)',
		require => Package['ceph'],
	}

}

