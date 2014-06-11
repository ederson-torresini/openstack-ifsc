# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-compute.html

class openstack-nova-compute {

	package { 'nova-compute-kvm':
		ensure => installed,
	}

	package { 'python-guestfs':
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
		subscribe => File['nova.conf'],
	}

	file { 'nova.conf':
		path => '/etc/nova/nova.conf',
		ensure => file,
		require => Package['nova-compute-kvm'],
		source => 'puppet:///modules/openstack-nova-compute/nova.conf',
		owner => root,
		group => nova,
		mode => 0640,
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

}

