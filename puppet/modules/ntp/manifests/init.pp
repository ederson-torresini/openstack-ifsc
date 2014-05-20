class ntp {

	package { 'ntp':
		ensure => installed,
		before => File['ntp.conf'],
	}

	service { 'ntp':
		name => $service_name,
		ensure => running,
		enable => true,
		subscribe => File['ntp.conf'],
	}

	file { 'ntp.conf':
		path => '/etc/ntp.conf',
		ensure => file,
		require => Package['ntp'],
		source => 'puppet:///modules/ntp/ntp.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

}

