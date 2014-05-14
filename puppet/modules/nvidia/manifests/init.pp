class nvidia {

	file { 'nvidia.conf':
		path => '/etc/modprobe.d/nvidia.conf',
		ensure => file,
		source => 'puppet:///modules/nvidia/nvidia.conf',
		owner => root,
		group => root,
		mode => 0644,
	}
}
