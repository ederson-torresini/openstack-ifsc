class dns {
	package { 'bind9':
		ensure => installed,
		before => File['named.conf', 'named.conf.options', 'named.conf.local', 'openstack.sj.ifsc.edu.br'],
	}

	service { 'bind9':
		name => 'bind9',
		ensure => running,
		enable => true,
		subscribe => File['named.conf', 'named.conf.options', 'named.conf.local', 'openstack.sj.ifsc.edu.br'],
	}

	file { 'named.conf':
		path => '/etc/bind/named.conf',
		ensure => file,
		require => Package['bind9'],
		source => 'puppet:///modules/dns/named.conf',
		owner => root,
		group => bind,
		mode => 0640,
	}

	file { 'named.conf.options':
		path => '/etc/bind/named.conf.options',
		ensure => file,
		require => Package['bind9'],
		source => 'puppet:///modules/dns/named.conf.options',
		owner => root,
		group => bind,
		mode => 0640,
	}

	file { 'named.conf.local':
		path => '/etc/bind/named.conf.local',
		ensure => file,
		require => Package['bind9'],
		source => 'puppet:///modules/dns/named.conf.local',
		owner => root,
		group => bind,
		mode => 0640,
	}

	file { 'openstack.sj.ifsc.edu.br':
		path => '/etc/bind/openstack.sj.ifsc.edu.br',
		ensure => file,
		require => Package['bind9'],
		source => 'puppet:///modules/dns/openstack.sj.ifsc.edu.br',
		owner => root,
		group => bind,
		mode => 0640,
	}
}
