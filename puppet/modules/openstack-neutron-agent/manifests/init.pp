class openstack-neutron-agent::common inherits openstack-neutron::common {

	file { 'sysctl.conf':
		path => '/etc/sysctl.conf',
		ensure => file,
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

	package { 'neutron-plugin-openvswitch-agent':
		ensure => installed,
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
		require => Package['neutron-plugin-openvswitch-agent'],
		unless => '/usr/bin/ovs-vsctl list-br | /bin/grep -q br-int',
	}

}

class openstack-neutron-agent::compute inherits openstack-neutron-agent::common {

	File <| title == 'sysctl.conf' |> {
		source => 'puppet:///modules/openstack-neutron-agent/sysctl-compute.conf',
	}

	File <| title == 'neutron.conf' |> {
		require => [
			Package['neutron-common'],
			Package['neutron-plugin-ml2'],
			Package['neutron-plugin-openvswitch-agent'],
		],
	}

	# http://openstack.redhat.com/Using_GRE_tenant_networks
	exec { 'ethtool:p5p1':
		command => '/sbin/ethtool -K p5p1 tso off lro off gro off gso off',
		onlyif => '/sbin/ip addr show p5p1',
	}

}

class openstack-neutron-agent::network inherits openstack-neutron-agent::common {

	File <| title == 'sysctl.conf' |> {
		source => 'puppet:///modules/openstack-neutron-agent/sysctl-network.conf',
	}

	File <| title == 'neutron.conf' |> {
		require => [
			Package['neutron-common'],
			Package['neutron-plugin-ml2'],
			Package['neutron-plugin-openvswitch-agent'],
			Package['neutron-l3-agent'],
			Package['neutron-metering-agent'],
			Package['neutron-dhcp-agent'],
		],
	}

	package { 'neutron-l3-agent':
		ensure => installed,
	}

	file { 'l3_agent.ini':
		path => '/etc/neutron/l3_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/l3_agent.ini',
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

	# Based on http://docs.openstack.org/admin-guide-cloud/content/install_neutron-metering-agent.html
	package { 'neutron-metering-agent':
		ensure => installed,
	}

	file { 'metering_agent.ini':
		path => '/etc/neutron/metering_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/metering_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-metering-agent'],
	}

	service { 'neutron-metering-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['metering_agent.ini'],
		],
	}

	package { 'neutron-dhcp-agent':
		ensure => installed,
	}

	file { 'dhcp_agent.ini':
		path => '/etc/neutron/dhcp_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/dhcp_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-dhcp-agent'],
	}

	file { 'dnsmasq-neutron.conf':
		path => '/etc/neutron/dnsmasq-neutron.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/dnsmasq-neutron.conf',
		owner => root,
		group => neutron,
		mode => 0640,
		require => File['dhcp_agent.ini'],
	}

	service { 'neutron-dhcp-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['dhcp_agent.ini'],
			File['dnsmasq-neutron.conf'],
		],
	}

	package { 'neutron-metadata-agent':
		ensure => installed,
	}

	file { 'metadata_agent.ini':
		path => '/etc/neutron/metadata_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/metadata_agent.ini',
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

	exec { 'br-ex':
		command => '/usr/bin/ovs-vsctl add-br br-ex',
		require => Package['neutron-plugin-openvswitch-agent'],
		unless => '/usr/bin/ovs-vsctl list-br | /bin/grep -q br-ex',
	}

	exec { 'add-port':
		command => '/usr/bin/ovs-vsctl add-port br-ex p5p1',
		unless => '/usr/bin/ovs-vsctl list-ports br-ex | /bin/grep -q p5p1',
		require => [
			Package['neutron-plugin-openvswitch-agent'],
			Exec['br-ex'],
		],
	}

}
