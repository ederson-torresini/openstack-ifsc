class openstack-cinder::common {

	package { 'cinder-common':
		ensure => installed,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder how to create this file.
	file { 'ceph.client.cinder.keyring':
		path => '/etc/ceph/ceph.client.cinder.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder/ceph.client.cinder.keyring',
		owner => root,
		group => cinder,
		mode => 0644,
		require => [
			Package['ceph'],
			Package['cinder-common'],
		],
	}

	exec { 'ceph auth caps client.cinder':
		command => '/usr/bin/ceph auth caps client.cinder mon \'allow r\' osd \'allow class-read object_prefix rbd_children, allow rwx pool=volumes, allow rx pool=images\'',
		subscribe => File['ceph.client.cinder.keyring'],
		refreshonly => true,
	}

	# Check http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder how to create this file.
	file { 'ceph.client.cinder-backup.keyring':
		path => '/etc/ceph/ceph.client.cinder-backup.keyring',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder/ceph.client.cinder-backup.keyring',
		owner => root,
		group => cinder,
		mode => 0644,
		require => [
			Package['ceph'],
			Package['cinder-common'],
		],
	}

	exec { 'ceph auth caps client.cinder-backup':
		command => '/usr/bin/ceph auth caps client.cinder-backup mon \'allow r\' osd \'allow class-read object_prefix rbd_children, allow rwx pool=backups\'',
		subscribe => File['ceph.client.cinder-backup.keyring'],
		refreshonly => true,
	}

	file { 'cinder.conf':
		path => '/etc/cinder/cinder.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder/cinder.conf',
		owner => root,
		group => cinder,
		mode => 0640,
	}

}

class openstack-cinder::controller inherits openstack-cinder::common {

	package { 'cinder-api':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'cinder-scheduler':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'cinder-backup':
		ensure => installed,
		require => [
			Package['cinder-api'],
			Package['cinder-scheduler'],
		],
	}

	service { 'cinder-api':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	service { 'cinder-scheduler':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	service { 'cinder-backup':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	file { '/var/lib/cinder/cinder.sqlite':
		ensure => absent,
	}

	file { '/etc/cinder/sql':
		ensure => directory,
		require => Package['cinder-api'],
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sql':
		path => '/etc/cinder/sql/cinder.sql',
		ensure => file,
		require => File['/etc/cinder/sql'],
		source => 'puppet:///modules/openstack-cinder/cinder.sql',
		owner => root,
		group => cinder,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/cinder/sql/cinder.sql':
		creates => '/var/lib/mysql/cinder',
		require => [
			File['cinder.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/cinder-manage db sync':
		creates => '/var/lib/mysql/cinder/volumes.frm',
		user => 'cinder',
		require => [
			Package['cinder-api'],
			Package['cinder-scheduler'],
			Exec['/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/cinder/sql/cinder.sql'],
		],
	}

	file { 'cinder-init.sh':
		path => '/usr/local/sbin/cinder-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder/cinder-init.sh',
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sh:link':
		path => '/etc/cinder/cinder-init.sh',
		ensure => link,
		target => '/usr/local/sbin/cinder-init.sh',
	}

	exec { '/usr/local/sbin/cinder-init.sh':
		subscribe => Exec['/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/cinder/sql/cinder.sql'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { 'pool volumes':
		command => '/usr/bin/ceph osd pool create volumes 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q volumes',
		require => Package['ceph'],
	}

	exec { 'size volumes':
		command => '/usr/bin/ceph osd pool set volumes size 2',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	exec { 'pg_num volumes':
		command => '/usr/bin/ceph osd pool set volumes pg_num 128',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	exec { 'pgp_num volumes':
		command => '/usr/bin/ceph osd pool set volumes pgp_num 128',
		subscribe => Exec['pool volumes'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { 'pool backups':
		command => '/usr/bin/ceph osd pool create backups 128',
		unless => '/usr/bin/rados lspools | /bin/grep -q backups',
		require => Package['ceph'],
	}

	exec { 'size backups':
		command => '/usr/bin/ceph osd pool set backups size 3',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

	exec { 'pg_num backups':
		command => '/usr/bin/ceph osd pool set backups pg_num 128',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

	exec { 'pgp_num backups':
		command => '/usr/bin/ceph osd pool set backups pgp_num 128',
		subscribe => Exec['pool backups'],
		refreshonly => true,
	}

}

class openstack-cinder::node inherits openstack-cinder::common {

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
		command => '/sbin/lvcreate -L 50G -n cinder openstack',
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

	file { '/var/lib/cinder':
		ensure => directory,
		owner => cinder,
		group => cinder,
		mode => 0775,
		require => Package['cinder-volume'],
	}   

	file { '/var/lib/cinder/volumes':
		ensure => directory,
		owner => cinder,
		group => cinder,
		mode => 0770,
		require => File['/var/lib/cinder'],
	}   
	
	file { '/var/lib/cinder/conversion':
		ensure => directory,
		owner => nova,
		group => cinder,
		mode => 0770,
		require => File['/var/lib/cinder'],
	}   


}
