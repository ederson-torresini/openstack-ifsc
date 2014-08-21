class openstack-cinder-node {

	package { 'cinder-volume':
		ensure => installed,
	}

	service { 'cinder-volume':
		ensure => running,
		enable => true,
		require => Package['cinder-volume'],
		subscribe => File['cinder.conf'],
	}

	# Issue #1: Create space, to allow conversion between glance and cinder, for large files.
	exec { 'lvcreate conversion':
		command => '/sbin/lvcreate -L 100G -n conversion openstack',
		unless => '/sbin/lvdisplay | /bin/grep -q conversion',
		require => Exec['/sbin/vgcreate openstack /dev/sda3'],
	}

	exec { 'mkfs conversion':
		command => '/sbin/mkfs.ext4 /dev/openstack/conversion',
		subscribe => Exec['lvcreate conversion'],
		refreshonly => true,
	}

	exec { 'fstab conversion':
		command => "/bin/echo /dev/openstack/conversion /var/lib/cinder/conversion ext4 rw,nodev,noexec,nosuid 0 2 >> /etc/fstab",
		unless => '/bin/grep -q /var/lib/cinder/conversion /etc/fstab',
		require => Exec['mkfs conversion'],
	}

	exec { 'mount conversion':
		command => '/bin/mount /var/lib/cinder/conversion',
		unless => '/bin/mount | /bin/grep -q conversion',
		require => Exec['fstab conversion'],
	}

}

