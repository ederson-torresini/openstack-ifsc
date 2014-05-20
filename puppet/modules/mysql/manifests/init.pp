class mysql {

	package { 'mysql-client':
		ensure => installed,
	}

	package { 'python-mysqldb':
		ensure => installed,
	}

	package { 'mysql-server':
		ensure => installed,
		before => File['my.cnf'],
	}

	service { 'mysql':
		ensure => running,
		enable => true,
		subscribe => File['my.cnf'],
	}

	file { 'my.cnf':
		path => '/etc/mysql/my.cnf',
		ensure => file,
		require => Package['mysql-server'],
		source => 'puppet:///modules/mysql/my.cnf',
		owner => root,
		group => root,
		mode => 0644,
	}

}

