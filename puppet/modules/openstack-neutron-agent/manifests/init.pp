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
	exec { 'ethtool:em1-gre':
		command => '/sbin/ethtool -K em1 tso off lro off gro off gso off',
		onlyif => '/sbin/ip addr show em1',
	}
	exec { 'ethtool:p5p1-gre':
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
			Package['neutron-vpn-agent'],
			Package['neutron-metering-agent'],
			Package['neutron-dhcp-agent'],
			Package['neutron-lbaas-agent'],
		],
	}

	# Based on https://gist.github.com/cloudnull/8851787
	package { 'neutron-l3-agent':
		ensure => absent,
	}

	package { 'openswan':
		ensure => installed,
	}

	package { 'neutron-vpn-agent':
		ensure => installed,
		require => [
			Package['openswan'],
			Package['neutron-l3-agent'],
		],
	}

	file { 'l3_agent.ini':
		path => '/etc/neutron/l3_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/l3_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-vpn-agent'],
	}

	file { 'vpn_agent.ini':
		path => '/etc/neutron/vpn_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/vpn_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-vpn-agent'],
	}

	service { 'neutron-l3-agent':
		ensure => stopped,
		enable => false,
	}

	service { 'ipsec':
		ensure => running,
		enable => true,
		require => Package['openswan'],
		subscribe => [
			File['vpn_agent.ini'],
		],
	}

	service { 'neutron-vpn-agent':
		ensure => running,
		enable => true,
		require => Service['neutron-l3-agent'],
		subscribe => [
			File['neutron.conf'],
			File['l3_agent.ini'],
			File['vpn_agent.ini'],
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

	# Based on http://docs.openstack.org/admin-guide-cloud/content/install_neutron-lbaas-agent.html
	package { 'neutron-lbaas-agent':
		ensure => installed,
	}

	file { 'lbaas_agent.ini':
		path => '/etc/neutron/lbaas_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron-agent/lbaas_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-lbaas-agent'],
	}

	service { 'neutron-lbaas-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['lbaas_agent.ini'],
		],
	}

	exec { 'br-ex':
		command => '/usr/bin/ovs-vsctl add-br br-ex',
		require => Package['neutron-plugin-openvswitch-agent'],
		unless => '/usr/bin/ovs-vsctl list-br | /bin/grep -q br-ex',
	}

	exec { 'add-port':
		command => '/usr/bin/ovs-vsctl add-port br-ex vlan448',
		unless => '/usr/bin/ovs-vsctl list-ports br-ex | /bin/grep -q vlan448',
		require => [
			Package['neutron-plugin-openvswitch-agent'],
			Exec['br-ex'],
		],
	}

}
