class users {

	group { 'rturnes':
		ensure => 'absent',
		gid => '1000',
	}

	group { 'etorresini':
		ensure => 'absent',
		gid => '1001',
	}

	group { 'git':
		ensure => 'present',
		gid => '10000',
	}

	user { 'rturnes':
		ensure => 'present',
		comment => 'Rafael Turnes Silveira',
		gid => '10000',
		groups => ['adm', 'sudo'],
		home => '/home/rturnes',
		shell => '/bin/bash',
		uid => '1000',
	}

	user { 'etorresini':
		ensure => 'present',
		comment => 'Ederson Torresini',
		gid => '10000',
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
		before => File['etorresini:.ssh'],
	}

	file { "etorresini:.ssh":
		path => '/home/etorresini/.ssh',
		ensure => directory,
		owner => etorresini,
		mode => 0700,
		before => File['etorresini:authorized_keys'],
	}

	file { 'etorresini:authorized_keys':
		path => '/home/etorresini/.ssh/authorized_keys',
		ensure => file,
		source => 'puppet:///modules/users/etorresini:authorized_keys',
		owner => etorresini,
		mode => 0400,
	}

}

