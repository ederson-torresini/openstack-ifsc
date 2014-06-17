# Based on http://docs.openstack.org/trunk/config-reference/content/configuring-openstack-compute-basics.html

class ceph-fs {

	file { 'client.cephfs.keyring':
		path => '/etc/ceph/client.cephfs.keyring',
		ensure => file,
		source => 'puppet:///modules/ceph-fs/client.cephfs.keyring',
		owner => root,
		group => root,
		mode => 0600,
	}

	file { 'client.cephfs.secret':
		path => '/etc/ceph/client.cephfs.secret',
		ensure => file,
		source => 'puppet:///modules/ceph-fs/client.cephfs.secret',
		owner => root,
		group => root,
		mode => 0600,
	}

	$source = $hostname ? {
		'openstack0' => '10.45.0.200',
		'openstack1' => '10.45.0.201',
		'openstack2' => '10.45.0.202',
	}

	exec { 'fstab:ceph':
		command => "/bin/echo $source:6789:/ /var/lib/nova/instances ceph name=cephfs,secretfile=/etc/ceph/client.cephfs.secret,noatime 0 0 >> /etc/fstab",
		unless => '/bin/grep -q /var/lib/nova/instances /etc/fstab',
	}

}

