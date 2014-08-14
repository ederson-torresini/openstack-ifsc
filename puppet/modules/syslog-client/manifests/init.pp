class syslog-client {

	package { 'rsyslog':
		ensure => installed,
	}

	file { 'client.conf':
		path => '/etc/rsyslog.d/99-openstack.conf',
		ensure => file,
		source => 'puppet:///modules/syslog-client/client.conf',
		owner => 'root',
		group => 'syslog',
		mode => 0640,
		require => Package['rsyslog'],
	}

	service { 'rsyslog':
		ensure => running,
		enable => true,
		subscribe => File['client.conf'],
	}

}

