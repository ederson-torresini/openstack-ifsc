class openstack-neutron-network-compute {

	file { 'sysctl.conf':
		path => '/etc/sysctl.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-network-compute/sysctl.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

	exec { 'sysctl':
		command => '/sbin/sysctl -p',
		subscribe => File['sysctl.conf'],
		refreshonly => true,
	}

	package { 'neutron-common':
		ensure => installed,
	}

	package { 'neutron-plugin-ml2':
		ensure => installed,
	}

	package { 'neutron-plugin-openvswitch-agent':
		ensure => installed,
	}

	package { 'neutron-l3-agent':
		ensure => installed,
	}

	package { 'neutron-dhcp-agent':
		ensure => installed,
	}

	package { 'neutron-metadata-agent':
		ensure => installed,
	}

	file { 'neutron.conf':
		path => '/etc/neutron/neutron.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-network-compute/neutron.conf',
		owner => root,
		group => neutron,
		mode => 0640,
		require => [
			Package['neutron-common'],
			Package['neutron-plugin-ml2'],
			Package['neutron-plugin-openvswitch-agent'],
			Package['neutron-l3-agent'],
			Package['neutron-dhcp-agent'],
		],
	}

	file { 'l3_agent.ini':
		path => '/etc/neutron/l3_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-network-compute/l3_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-l3-agent'],
	}

	service { 'neutron-l3-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['l3_agent.ini'],
		],
	}

	file { 'dhcp_agent.ini':
		path => '/etc/neutron/dhcp_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-network-compute/dhcp_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-dhcp-agent'],
	}

	service { 'neutron-dhcp-agent':
		#ensure => running,
		ensure => stopped,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['dhcp_agent.ini'],
		],
	}

	file { 'metadata_agent.ini':
		path => '/etc/neutron/metadata_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-network-compute/metadata_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-metadata-agent'],
	}

	service { 'neutron-metadata-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['metadata_agent.ini'],
		],
	}

	$source = $hostname ? {
		'openstack1' => 'puppet:///modules/openstack-neutron-network-compute/ml2_conf.ini-openstack1',
		'openstack2' => 'puppet:///modules/openstack-neutron-network-compute/ml2_conf.ini-openstack2',
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

	service { 'neutron-plugin-openvswitch-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['ml2_conf.ini'],
		],
	}

	exec { 'br-int':
		command => '/usr/bin/ovs-vsctl add-br br-int',
		creates => '/etc/neutron/done',
	}

	exec { 'br-ex':
		command => '/usr/bin/ovs-vsctl add-br br-ex',
		before => Exec['add-port'],
		creates => '/etc/neutron/done',
	}

	exec { 'add-port':
		command => '/usr/bin/ovs-vsctl add-port br-ex p5p1',
		creates => '/etc/neutron/done',
	}

	file { 'done':
		path => '/etc/neutron/done',
		ensure => file,
		owner => root,
		group => neutron,
		mode => 0640,
		require => [
			Exec['br-int'],
			Exec['br-ex'],
			Exec['add-port'],
		],
	}

}

