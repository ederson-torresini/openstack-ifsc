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
	exec { 'lvcreate cinder':
		command => '/sbin/lvcreate -L 100G -n cinder openstack',
		unless => '/sbin/lvdisplay | /bin/grep -q cinder',
		require => Exec['/sbin/vgcreate openstack /dev/sda3'],
	}

	exec { 'mkfs cinder':
		command => '/sbin/mkfs.ext4 /dev/openstack/cinder',
		subscribe => Exec['lvcreate cinder'],
		refreshonly => true,
	}

	exec { 'fstab cinder':
		command => "/bin/echo /dev/openstack/cinder /var/lib/cinder ext4 rw,nodev,noexec,nosuid 0 2 >> /etc/fstab",
		unless => '/bin/grep -q /var/lib/cinder /etc/fstab',
		require => Exec['mkfs cinder'],
	}

	exec { 'mount cinder':
		command => '/bin/mount /var/lib/cinder',
		unless => '/bin/mount | /bin/grep -q cinder',
		require => Exec['fstab cinder'],
	}

	file { [
			'/var/lib/cinder',
			'/var/lib/cinder/conversion',
			'/var/lib/cinder/volumes',
		]:
		ensure => directory,
		owner => cinder,
		group => cinder,
		mode => 0770,
	}

}

