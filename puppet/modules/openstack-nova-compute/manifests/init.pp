# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-compute.html
class openstack-nova-compute {

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	group { 'nova':
		gid => '10000',
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	group { 'kvm':
		gid => '10001',
	}

	group { 'libvirtd':
		gid => '10002',
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	user { 'nova':
		uid => '10000',
		gid  => '10000',
		home => '/var/lib/nova',
		shell => '/bin/sh',
		require => [
			Group['nova'],
			Group['libvirtd'],
		],
	}

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	user { 'libvirt-qemu':
		uid => '10001',
		gid => '10001',
		home => '/var/lib/libvirt',
		shell => '/bin/false',
		require => Group['kvm'],
	}

	package { 'nova-compute':
		ensure => installed,
		require => User['nova'],
	}

	package { 'nova-compute-kvm':
		ensure => installed,
		require => User['nova'],
	}

	package { 'python-guestfs':
		ensure => installed,
	}

	package { 'libvirt-bin':
		ensure => installed,
		require => User['libvirt-qemu'],
	}

	package { 'qemu-kvm':
		ensure => installed,
	}

	exec { 'dpkg-statoverride':
		command => '/usr/bin/dpkg-statoverride --update --add root root 0644 /boot/vmlinuz-$(uname -r)',
		creates => '/etc/kernel/postinst.d/statoverride',
	}

	file { '/etc/kernel/postinst.d/statoverride':
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/statoverride',
		owner => root,
		group => nova,
		mode => 0740,
		require => Exec['dpkg-statoverride'],
	}

	service { 'nova-compute':
		ensure => running,
		enable => true,
		subscribe => [
			User['nova'],
			File['nova.conf'],
			File['nova-compute.conf'],
		],
	}

	$source = $hostname ? {
		'openstack1' => 'puppet:///modules/openstack-nova-compute/nova.conf-openstack1',
		'openstack2' => 'puppet:///modules/openstack-nova-compute/nova.conf-openstack2',
		'openstack3' => 'puppet:///modules/openstack-nova-compute/nova.conf-openstack3',
	}

	file { 'nova.conf':
		path => '/etc/nova/nova.conf',
		ensure => file,
		require => Package['nova-compute'],
		source => $source,
		owner => root,
		group => nova,
		mode => 0640,
	}

	file { 'nova-compute.conf':
		path => '/etc/nova/nova-compute.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/nova-compute.conf',
		owner => root,
		group => nova,
		mode => 0644,
		require => Package['nova-compute'],
	}

	file { '/var/lib/nova/nova.sqlite':
		ensure => absent,
	}

    # Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder how to create this file.
    file { 'secret.xml':
        path => '/etc/libvirt/secret.xml',
        ensure => file,
        source => 'puppet:///modules/openstack-nova-compute/secret.xml',
        owner => root,
        group => libvirtd,
        mode => 0640,
		require => [
			File['ceph.client.cinder.keyring'],
			File['cinder.conf'],
		],
    }

    exec { 'virsh secret-define':
		command => '/usr/bin/virsh secret-define --file /etc/libvirt/secret.xml',
		subscribe => File['secret.xml'],
		refreshonly => true,
	}

	exec { 'virsh secret-set-value':
		command => '/usr/bin/virsh secret-set-value --secret 2947f939-8703-419f-b6ba-9d6b1220b540 --base64 AQCWxZdTeIWOLRAAX8ts7geVTfVxy7egZlz15w==',
		require => Exec['virsh secret-define'],
		subscribe => File['secret.xml'],
		refreshonly => true,
	}

	# Check http://www.sebastien-han.fr/blog/2012/06/10/introducing-ceph-to-openstack/ (section "EDIT: 11/07/2012") why to introduce this line to file.
	exec { 'apparmor:libvirt-qemu':
        command => "/bin/echo '/etc/ceph/ceph.client.cinder.keyring r,\n/tmp/ r,\n/var/tmp/ r,' >> /etc/apparmor.d/abstractions/libvirt-qemu",
        unless => '/bin/grep -q keyring /etc/apparmor.d/abstractions/libvirt-qemu',
    }

	service { 'apparmor':
		ensure => running,
		enable => true,
		subscribe => Exec['apparmor:libvirt-qemu'],
	}

	# From here to the end: http://docs.openstack.org/trunk/config-reference/content/section_configuring-compute-migrations.html
	file { 'libvirtd.conf':
		path => '/etc/libvirt/libvirtd.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/libvirtd.conf',
		owner => root,
		group => libvirtd,
		mode => 0640,
		require => Package['libvirt-bin'],
	}

	file { 'libvirt-bin':
		path => '/etc/default/libvirt-bin',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/libvirt-bin',
		owner => root,
		group => libvirtd,
		mode => 0640,
		require => Package['libvirt-bin'],
	}

	file { 'qemu.conf':
		path => '/etc/libvirt/qemu.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/qemu.conf',
		owner => root,
		group => libvirtd,
		mode => 0640,
		require => Package['libvirt-bin'],
	}

	service { 'libvirt-bin':
		ensure => running,
		enable => true,
		subscribe => [
			User['libvirt-qemu'],
			Group['kvm'],
			File['nova.conf'],
			File['libvirtd.conf'],
			File['libvirt-bin'],
			File['qemu.conf'],
			Exec['apparmor:libvirt-qemu'],
		],
	}

	file { '.ssh':
		path => '/var/lib/nova/.ssh',
		ensure => directory,
		owner => nova,
		group => nova,
		mode => 0700,
		require => Package['openssh-server'],
	}

	file { 'id_rsa':
		path => '/var/lib/nova/.ssh/id_rsa',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/id_rsa',
		owner => nova,
		group => nova,
		mode => 0400,
		require => File['.ssh'],
	}

	file { 'id_rsa.pub':
		path => '/var/lib/nova/.ssh/id_rsa.pub',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/id_rsa.pub',
		owner => nova,
		group => nova,
		mode => 0400,
		require => File['.ssh'],
	}

	file { 'authorized_keys':
		path => '/var/lib/nova/.ssh/authorized_keys',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/id_rsa.pub',
		owner => nova,
		group => nova,
		mode => 0400,
		require => File['id_rsa.pub'],
	}

	exec { 'nova:shell':
		command => '/usr/bin/chsh -s /bin/sh nova',
		subscribe => File['authorized_keys'],
		refreshonly => true,
	}

}

