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

}

