class haproxy {

	package { 'haproxy':
		ensure => installed,
	}

	file { 'haproxy.cfg':
		path => '/etc/haproxy/haproxy.cfg',
		source => 'puppet:///modules/haproxy/haproxy.cfg',
		owner => root,
		group => haproxy,
		mode => 0640,
		require => Package['haproxy'],
	}

	file { 'haproxy':
		path => '/etc/default/haproxy',
		source => 'puppet:///modules/haproxy/haproxy',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['haproxy'],
	}

	service { 'haproxy':
		ensure => running,
		enable => true,
		subscribe => [
			File['haproxy.cfg'],
			File['haproxy'],
		],
	}

}
