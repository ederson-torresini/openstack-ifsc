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

}

