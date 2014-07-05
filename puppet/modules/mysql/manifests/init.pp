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

	file { 'my.cnf':
		path => '/etc/mysql/my.cnf',
		ensure => file,
		require => Package['mysql-server'],
		source => 'puppet:///modules/mysql/my.cnf',
		owner => root,
		group => root,
		mode => 0644,
	}

	service { 'mysql':
		ensure => running,
		enable => true,
		subscribe => File['my.cnf'],
	}

	file { 'backup.mysql':
		path => '/etc/cron.daily/backup.mysql',
		ensure => file,
		source => 'puppet:///modules/mysql/backup.mysql',
		owner => root,
		group => mysql,
		mode => 0750,
		require => [
			Package['mysql-client'],
			Package['mysql-server'],
		],
	}

}

