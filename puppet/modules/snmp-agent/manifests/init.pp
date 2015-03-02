# Based on https://www.zabbix.com/documentation/2.2/manual/installation/install_from_packages

class snmp-agent {

	package { 'zabbix-agent':
		ensure => installed,
	}

	file { 'zabbix_agentd.conf':
		path => '/etc/zabbix/zabbix_agentd.conf',
		source => 'puppet:///modules/snmp-agent/zabbix_agentd.conf',
		owner => root,
		group => zabbix,
		mode => 0640,
		require => Package['zabbix-agent'],
	}

	service { 'zabbix-agent':
		ensure => running,
		enable => true,
		require => Package['zabbix-agent'],
		subscribe => File['zabbix_agentd.conf'],
	}

	package { 'snmpd':
		ensure => installed,
	}

	file { 'snmpd.conf':
		path => '/etc/snmp/snmpd.conf',
		source => 'puppet:///modules/snmp-agent/snmpd.conf',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['snmpd'],
	}

	service { 'snmpd':
		ensure => running,
		enable => true,
		require => Package['snmpd'],
		subscribe => FIle['snmpd.conf'],
	}

}

