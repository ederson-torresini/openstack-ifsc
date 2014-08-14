class syslog-server {

	package { 'rsyslog':
		ensure => installed,
	}

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
		source => 'puppet:///modules/syslog-server/server.conf',
		owner => 'root',
		group => 'syslog',
		mode => 0640,
		require => [
			Package['rsyslog'],
			File['rsyslog:dir'],
		],
	}

	service { 'rsyslog':
		ensure => running,
		enable => true,
		subscribe => File['server.conf'],
	}

	file { 'logrotate.conf':
		path => '/etc/logrotate.d/openstack',
		ensure => file,
		source => 'puppet:///modules/syslog-server/logrotate.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

}

