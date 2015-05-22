class mysql {

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

	file { 'root.sql':
		path => '/etc/mysql/root.sql',
		ensure => file,
		source => 'puppet:///modules/mysql/root.sql',
		owner => root,
		group => mysql,
		mode => 0640,
		require => Package['mysql-server'],
	}

	exec { 'mysql -u root -h mysql < /etc/mysql/root.sql':
		path => '/usr/bin',
		require => [
			Package['mysql-client'],
			File['root.sql'],
			Service['mysql'],
		],
		onlyif => 'mysql -u root -h mysql -e "show databases;"',
	}

	file { 'backup-mysql':
		path => '/etc/cron.daily/backup-mysql',
		ensure => file,
		source => 'puppet:///modules/mysql/backup-mysql',
		owner => root,
		group => mysql,
		mode => 0750,
		require => [
			Package['mysql-client'],
			Package['mysql-server'],
		],
	}

}
