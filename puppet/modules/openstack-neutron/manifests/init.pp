class openstack-neutron::common {

	package { 'neutron-plugin-ml2':
		ensure => installed,
	}

	$source = $hostname ? {
		'openstack0' => 'puppet:///modules/openstack-neutron/ml2_conf.ini-openstack0',
		'openstack1' => 'puppet:///modules/openstack-neutron/ml2_conf.ini-openstack1',
		'openstack2' => 'puppet:///modules/openstack-neutron/ml2_conf.ini-openstack2',
		'openstack3' => 'puppet:///modules/openstack-neutron/ml2_conf.ini-openstack3',
	}

	file  { 'ml2_conf.ini':
		path => '/etc/neutron/plugins/ml2/ml2_conf.ini',
		ensure => file,
		source => $source,
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-plugin-ml2'],
	}

	file { 'neutron.conf':
		path => '/etc/neutron/neutron.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron/neutron.conf',
		owner => root,
		group => neutron,
		mode => 0640,
	}

}
