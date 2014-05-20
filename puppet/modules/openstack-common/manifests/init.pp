class openstack-common {

	package { 'python-setuptools':
		ensure => installed,
	}

	package { 'python-pip':
		ensure => installed,
	}

	package { 'python-keystoneclient':
		ensure => installed,
	}

}
