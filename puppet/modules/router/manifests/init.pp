class router {

	file { 'sysctl.conf':
		path => '/etc/sysctl.conf',
		ensure => file,
		source => 'puppet:///modules/router/sysctl.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

	exec{ '/sbin/sysctl -p /etc/sysctl.conf':
		subscribe => File['sysctl.conf'],
		refreshonly => true,
	}

	file { 'iptables.sh':
		path => '/usr/local/sbin/iptables.sh',
		ensure => file,
		source => 'puppet:///modules/router/iptables.sh',
		owner => root,
		group => root,
		mode => 0700,
	}

	exec { 'iptables.sh':
		command => '/usr/local/sbin/iptables.sh',
		subscribe => File['iptables.sh'],
		refreshonly => true,
	}

	file { 'iptables':
		path => '/etc/init.d/iptables',
		ensure => file,
		source => 'puppet:///modules/router/iptables',
		owner => root,
		group => root,
		mode => 0750,
	}

	exec { '/usr/sbin/update-rc.d iptables defaults':
		require => File['iptables'],
		subscribe => File['iptables.sh'],
		refreshonly => true,
	}

}

