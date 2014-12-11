# Based on http://docs.openstack.org/icehouse/install-guide/install/apt/content/nova-compute.html
class openstack-nova-compute::common inherits openstack-nova::common {

	package { 'nova-compute':
		ensure => installed,
		require => User['nova'],
	}

	file { 'nova-compute.conf':
		path => '/etc/nova/nova-compute.conf',
		ensure => file,
		owner => root,
		group => nova,
		mode => 0644,
		require => Package['nova-compute'],
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

}

class openstack-nova-compute::kvm inherits openstack-nova-compute::common {

	# Based on https://www.mirantis.com/blog/tutorial-openstack-live-migration-with-kvm-hypervisor-and-nfs-shared-storage/
	User['nova'] {
		groups => ['libvirtd'],
		require => [
			Group['nova'],
			Group['libvirtd'],
		],
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

	# Based on https://coreos.com/docs/running-coreos/platforms/openstack/
	# and http://docs.openstack.org/user-guide/content/requirements.html
	package { 'genisoimage':
		ensure => installed,
	}

	# Based on http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder
	file { 'secret.xml':
		path => '/etc/libvirt/secret.xml',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/secret.xml',
		owner => root,
		group => libvirtd,
		mode => 0640,
		require => [
			Package['libvirt-bin'],
			File['ceph.client.cinder.keyring'],
			File['cinder.conf'],
		],
	}

	# Based on http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder
	exec { 'virsh secret-define':
		command => '/usr/bin/virsh secret-define --file /etc/libvirt/secret.xml',
		subscribe => File['secret.xml'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rbd/rbd-openstack/?highlight=cinder
	exec { 'virsh secret-set-value':
		command => '/usr/bin/virsh secret-set-value --secret 2947f939-8703-419f-b6ba-9d6b1220b540 --base64 AQCWxZdTeIWOLRAAX8ts7geVTfVxy7egZlz15w==',
		require => Exec['virsh secret-define'],
		subscribe => File['secret.xml'],
		refreshonly => true,
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

	File['nova-compute.conf'] {
		source => 'puppet:///modules/openstack-nova-compute/nova-compute-kvm.conf',
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

}

# Based on https://wiki.openstack.org/wiki/Docker
class openstack-nova-compute::docker inherits openstack-nova-compute::common {

	# Based on https://docs.docker.com/installation/ubuntulinux/#ubuntu-trusty-1404-lts-64-bit
	package { 'docker.io':
		ensure => absent,
	}

	# Based on https://docs.docker.com/installation/ubuntulinux/#ubuntu-trusty-1404-lts-64-bit
	file { 'docker.list':
		path => '/etc/apt/sources.list.d/docker.list',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/docker.list',
		owner => root,
		group => root,
		mode => 0644,
	}

	# Based on https://docs.docker.com/installation/ubuntulinux/#ubuntu-trusty-1404-lts-64-bit
	exec { 'docker apt-key':
		command => '/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9',
		unless => '/usr/bin/apt-key list | grep -qi docker',
	}

	# Based on https://docs.docker.com/installation/ubuntulinux/#ubuntu-trusty-1404-lts-64-bit
	exec { 'aptitude update':
		command => '/usr/bin/aptitude update',
		require => Exec['docker apt-key'],
		subscribe => File['docker.list'],
		refreshonly => true,
	}

	# Based on https://docs.docker.com/installation/ubuntulinux/#ubuntu-trusty-1404-lts-64-bit
	package { 'lxc-docker':
		ensure => installed,
		require => [
			File['docker.list'],
			Exec['docker apt-key'],
			Exec['aptitude update'],
		],
	}

	User['nova'] {
		groups => ['docker'],
		require => [
			Group['nova'],
			Package['lxc-docker'],
		],
	}

	package { 'nova-docker':
		provider => pip,
		ensure => installed,
		source => 'git+https://github.com/stackforge/nova-docker#egg=novadocker',
		require => Package['lxc-docker'],
	}

	File['nova-compute.conf'] {
		source => 'puppet:///modules/openstack-nova-compute/nova-compute-docker.conf',
	}

	file { 'docker.filters':
		path => '/etc/nova/rootwrap.d/docker.filters',
		ensure => file,
		source => 'puppet:///modules/openstack-nova-compute/docker.filters',
		owner => root,
		group => nova,
		mode => 0644,
		require => [
			Package['nova-compute'],
			Package['lxc-docker'],
		],
	}

	# Issue #8: More space to Docker runtime files.
	exec { 'lvcreate docker':
		command => '/sbin/lvcreate -L 20G -n docker openstack',
		unless => '/sbin/lvdisplay | /bin/grep -q docker',
		require => Exec['/sbin/vgcreate openstack /dev/sda3'],
	}

	exec { 'mkfs docker':
		command => '/sbin/mkfs.ext4 /dev/openstack/docker',
		subscribe => Exec['lvcreate docker'],
		refreshonly => true,
	}

	file { 'docker':
		path => '/var/lib/docker',
		ensure => directory,
		owner => root,
		group => docker,
		mode => 0770,
	}

	exec { 'fstab docker':
		command => "/bin/echo /dev/openstack/docker /var/lib/docker ext4 defaults 0 2 >> /etc/fstab",
		unless => '/bin/grep -q /var/lib/docker /etc/fstab',
		require => [
			Exec['mkfs docker'],
			File['docker'],
		],
	}

	exec { 'mount docker':
		command => '/bin/mount /var/lib/docker',
		unless => '/bin/mount | /bin/grep -q docker',
		require => Exec['fstab docker'],
	}

	exec { 'make rprivate docker':
		command => '/bin/mount --make-rprivate /var/lib/docker',
		subscribe => Exec['mount docker'],
		refreshonly => true,
	}

	Service['nova-compute'] {
		subscribe => [
			User['nova'],
			File['nova.conf'],
			File['nova-compute.conf'],
			File['docker.filters'],
		],
	}

	service { 'docker':
		ensure => running,
		enable => true,
		subscribe => [
			File['docker.filters'],
			File['docker'],
			Exec['make rprivate docker'],
		],
	}

}
