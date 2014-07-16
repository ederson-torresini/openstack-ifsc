class ntp {

	package { 'ntp':
		ensure => installed,
	}

	file { 'ntp.conf':
		path => '/etc/ntp.conf',
		ensure => file,
		source => 'puppet:///modules/ntp/ntp.conf',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['ntp'],
	}

	service { 'ntp':
		name => 'ntp',
		ensure => running,
		enable => true,
		subscribe => File['ntp.conf'],
	}

}

