class users {

	group { 'etorresini':
		ensure => absent,
		gid => '1001',
	}

	group { 'humbertos':
		ensure => absent,
		gid => '1002',
	}

	group { 'git':
		ensure => 'present',
		gid => '9999',
	}

	user { 'etorresini':
		ensure => 'present',
		comment => 'Ederson Torresini',
		gid => '9999',
		groups => ['adm', 'sudo'],
		home => '/home/etorresini',
		shell => '/bin/bash',
		uid => '1001',
	}

	file { "etorresini:home":
		path => '/home/etorresini',
		ensure => directory,
		owner => etorresini,
		mode => 0700,
	}

	file { "etorresini:.ssh":
		path => '/home/etorresini/.ssh',
		ensure => directory,
		owner => etorresini,
		mode => 0700,
		require => File['etorresini:home'],
	}

	file { 'etorresini:authorized_keys':
		path => '/home/etorresini/.ssh/authorized_keys',
		ensure => file,
		source => 'puppet:///modules/users/etorresini:authorized_keys',
		owner => etorresini,
		mode => 0400,
		require => File['etorresini:.ssh'],
	}

	user { 'humbertos':
		ensure => 'present',
		comment => 'Humberto Jose de Souza',
		gid => '9999',
		groups => ['adm', 'sudo'],
		home => '/home/humbertos',
		shell => '/bin/bash',
		uid => '1002',
	}

	file { "humbertos:home":
		path => '/home/humbertos',
		ensure => directory,
		owner => humbertos,
		mode => 0700,
	}

	file { "humbertos:.ssh":
		path => '/home/humbertos/.ssh',
		ensure => directory,
		owner => humbertos,
		mode => 0700,
		require => File['humbertos:home'],
	}

	file { 'humbertos:authorized_keys':
		path => '/home/humbertos/.ssh/authorized_keys',
		ensure => file,
		source => 'puppet:///modules/users/humbertos:authorized_keys',
		owner => humbertos,
		mode => 0400,
		require => File['humbertos:.ssh'],
	}

}
