class dns {

	package { 'bind9':
		ensure => installed,
	}

	file { 'named.conf':
		path => '/etc/bind/named.conf',
		ensure => file,
		owner => root,
		group => bind,
		mode => 0640,
		require => Package['bind9'],
	}

	service { 'bind9':
		name => 'bind9',
		ensure => running,
		enable => true,
		subscribe => [
			File['named.conf'],
		],
	}

}

class dns::master inherits dns {

	File <| title == 'named.conf' |> {
		source => 'puppet:///modules/dns/named.conf-master',
	}

	file { 'openstack.sj.ifsc.edu.br-internal':
		path => '/etc/bind/openstack.sj.ifsc.edu.br-internal',
		ensure => file,
		source => 'puppet:///modules/dns/openstack.sj.ifsc.edu.br-internal',
		owner => root,
		group => bind,
		mode => 0640,
		require => Package['bind9'],
	}

	file { 'openstack.sj.ifsc.edu.br-external':
		path => '/etc/bind/openstack.sj.ifsc.edu.br-external',
		ensure => file,
		source => 'puppet:///modules/dns/openstack.sj.ifsc.edu.br-external',
		owner => root,
		group => bind,
		mode => 0640,
		require => Package['bind9'],
	}

	Service <| title == 'bind9' |> {
		subscribe => [
			File['named.conf'],
			File['openstack.sj.ifsc.edu.br-internal'],
			File['openstack.sj.ifsc.edu.br-external'],
		],
	}

}

class dns::slave inherits dns {

	File <| title == 'named.conf' |> {
		source => 'puppet:///modules/dns/named.conf-slave',
	}

}
