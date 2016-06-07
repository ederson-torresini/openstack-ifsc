class openstack-neutron::common {

	package { 'neutron-common':
		ensure => installed,
	}

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
		source => $source,
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-plugin-ml2'],
	}

	file { 'ovs_neutron_plugin.ini':
		path => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
		source => 'puppet:///modules/openstack-neutron/ovs_neutron_plugin.ini',
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

class openstack-neutron::controller inherits openstack-neutron::common {

	package { 'neutron-server':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	File <| title == 'neutron.conf' |> {
		require => Package['neutron-server'],
	}

	service { 'neutron-server':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['ml2_conf.ini'],
			File['ovs_neutron_plugin.ini'],
		],
	}

	file { '/var/lib/neutron/neutron.sqlite':
		ensure => absent,
	}

	file { '/etc/neutron/sql':
		ensure => directory,
		require => Package['neutron-server'],
		owner => root,
		group => neutron,
		mode => 0750,
	}

	file { 'neutron.sql':
		path => '/etc/neutron/sql/neutron.sql',
		ensure => file,
		require => File['/etc/neutron/sql'],
		source => 'puppet:///modules/openstack-neutron/neutron.sql',
		owner => root,
		group => neutron,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/neutron/sql/neutron.sql':
		creates => '/var/lib/mysql/neutron',
		require => [
			File['neutron.sql'],
			Class['mysql'],
		],
	}

	file { 'neutron-init.sh':
		path => '/usr/local/sbin/neutron-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron/neutron-init.sh',
		owner => root,
		group => neutron,
		mode => 0750,
	}

	file { 'neutron.sh:link':
		path => '/etc/neutron/neutron-init.sh',
		ensure => link,
		target => '/usr/local/sbin/neutron-init.sh',
	}

	exec { '/usr/local/sbin/neutron-init.sh':
		subscribe => Exec['/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/neutron/sql/neutron.sql'],
		refreshonly => true,
	}

}

class openstack-neutron::agent::common inherits openstack-neutron::common {

	package { 'neutron-plugin-openvswitch-agent':
		ensure => installed,
	}

	service { 'neutron-plugin-openvswitch-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['ml2_conf.ini'],
			File['ovs_neutron_plugin.ini'],
		],
	}

	exec { 'br-int':
		command => '/usr/bin/ovs-vsctl add-br br-int',
		require => Package['neutron-plugin-openvswitch-agent'],
		unless => '/usr/bin/ovs-vsctl list-br | /bin/grep -q br-int',
	}

}

class openstack-neutron::agent::compute inherits openstack-neutron::agent::common {

	file { 'sysctl-openstack-neutron-agent-compute.conf':
		path => '/etc/sysctl-openstack-neutron-agent-compute.conf',
		source => 'puppet:///modules/openstack-neutron/sysctl-compute.conf',
		ensure => file,
		owner => root,
		group => root,
		mode => 0644,
	}

	exec { 'sysctl:sysctl-openstack-neutron-agent-compute.conf':
		command => '/sbin/sysctl -p /etc/sysctl-openstack-neutron-agent-compute.conf',
		require => File['sysctl-openstack-neutron-agent-compute.conf'],
	}

	File <| title == 'neutron.conf' |> {
		require => [
			Package['neutron-common'],
			Package['neutron-plugin-ml2'],
			Package['neutron-plugin-openvswitch-agent'],
		],
	}

}

class openstack-neutron::agent::network inherits openstack-neutron::agent::common {

	file { 'sysctl-openstack-neutron-agent-network.conf':
		path => '/etc/sysctl-openstack-neutron-agent-network.conf',
		source => 'puppet:///modules/openstack-neutron/sysctl-network.conf',
		ensure => file,
		owner => root,
		group => root,
		mode => 0644,
	}

	exec { 'sysctl:sysctl-openstack-neutron-agent-network.conf':
		command => '/sbin/sysctl -p /etc/sysctl-openstack-neutron-agent-network.conf',
		require => File['sysctl-openstack-neutron-agent-network.conf'],
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
		ensure => installed,
	}

	package { 'openswan':
		ensure => installed,
	}

	package { 'neutron-vpn-agent':
		ensure => absent,
		require => [
			Package['openswan'],
			Package['neutron-l3-agent'],
		],
	}

	file { 'l3_agent.ini':
		path => '/etc/neutron/l3_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron/l3_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-vpn-agent'],
	}

	file { 'vpn_agent.ini':
		path => '/etc/neutron/vpn_agent.ini',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron/vpn_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-vpn-agent'],
	}

	service { 'ipsec':
		ensure => stopped,
		enable => false,
		require => Package['openswan'],
		subscribe => [
			File['vpn_agent.ini'],
		],
	}

	service { 'neutron-l3-agent':
		ensure => running,
		enable => true,
		subscribe => [
			File['neutron.conf'],
			File['l3_agent.ini'],
		],
	}

	service { 'neutron-vpn-agent':
		ensure => stopped,
		enable => false,
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
		source => 'puppet:///modules/openstack-neutron/metering_agent.ini',
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
		source => 'puppet:///modules/openstack-neutron/dhcp_agent.ini',
		owner => root,
		group => neutron,
		mode => 0640,
		require => Package['neutron-dhcp-agent'],
	}

	file { 'dnsmasq-neutron.conf':
		path => '/etc/neutron/dnsmasq-neutron.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-neutron/dnsmasq-neutron.conf',
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
		source => 'puppet:///modules/openstack-neutron/metadata_agent.ini',
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
		source => 'puppet:///modules/openstack-neutron/lbaas_agent.ini',
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
