class syslog {

	package { 'rsyslog':
		ensure => installed,
	}

	service { 'rsyslog':
		ensure => running,
		enable => true,
	}

}

class syslog::server inherits syslog {

	file { 'rsyslog:dir':
		path => '/var/log/openstack',
		ensure => directory,
		owner => root,
		group => syslog,
		mode => 0770,
	}

	file { 'server.conf':
		path => '/etc/rsyslog.d/99-openstack.conf',
		ensure => file,
		source => 'puppet:///modules/syslog/server.conf',
		owner => 'root',
		group => 'syslog',
		mode => 0640,
		require => [
			Package['rsyslog'],
			File['rsyslog:dir'],
		],
	}

	Service <| title == 'rsyslog' |> {
		subscribe => File['server.conf'],
	}

	file { 'logrotate.conf':
		path => '/etc/logrotate.d/openstack',
		ensure => file,
		source => 'puppet:///modules/syslog/logrotate.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

}

class syslog::client inherits syslog {

	file { 'client.conf':
		path => '/etc/rsyslog.d/99-openstack.conf',
		ensure => file,
		source => 'puppet:///modules/syslog/client.conf',
		owner => 'root',
		group => 'syslog',
		mode => 0640,
		require => Package['rsyslog'],
	}

	Service <| title == 'rsyslog' |> {
		subscribe => File['client.conf'],
	}

}
