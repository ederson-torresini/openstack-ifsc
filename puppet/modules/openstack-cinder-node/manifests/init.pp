class openstack-cinder-node {

	package { 'cinder-volume':
		ensure => installed,
	}

}

