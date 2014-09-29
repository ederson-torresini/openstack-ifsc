class openstack-nova::common {

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	group { 'nova':
		gid => '10000',
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	group { 'kvm':
		gid => '10001',
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	group { 'libvirtd':
		gid => '10002',
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	user { 'nova':
		uid => '10000',
		gid  => '10000',
		home => '/var/lib/nova',
		shell => '/bin/sh',
		require => Group['nova'],
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	user { 'libvirt-qemu':
		uid => '10001',
		gid => '10001',
		home => '/var/lib/libvirt',
		shell => '/bin/false',
		require => Group['kvm'],
	}

	package { 'nova-common':
		ensure => installed,
		require => User['nova'],
	}

	file { '/var/lib/nova/nova.sqlite':
		ensure => absent,
	}

	$source = $hostname ? {
		'openstack0' => 'puppet:///modules/openstack-nova/nova.conf-openstack0',
		'openstack1' => 'puppet:///modules/openstack-nova/nova.conf-openstack1',
		'openstack2' => 'puppet:///modules/openstack-nova/nova.conf-openstack2',
		'openstack3' => 'puppet:///modules/openstack-nova/nova.conf-openstack3',
	}

	file { 'nova.conf':
		path => '/etc/nova/nova.conf',
		ensure => file,
		source => $source,
		owner => root,
		group => nova,
		mode => 0640,
		require => Package['nova-common'],
	}

}
