# Based on https://www.zabbix.com/documentation/2.2/manual/installation/install_from_packages

class snmp-manager {

	package { 'zabbix-server-mysql':
		ensure => installed,
	}

	file { 'zabbix_server.conf':
		path => '/etc/zabbix/zabbix_server.conf',
		source => 'puppet:///modules/snmp-manager/zabbix_server.conf',
		owner => root,
		group => zabbix,
		mode => 0640,
		require => Package['zabbix-server-mysql'],
	}

	file { '/etc/zabbix/sql':
		ensure => directory,
		owner => root,
		group => zabbix,
		mode => 0750,
		require => Package['zabbix-server-mysql'],
	}

	file { 'zabbix_server.sql':
		path => '/etc/zabbix/sql/zabbix_server.sql',
		source => 'puppet:///modules/snmp-manager/zabbix_server.sql',
		owner => root,
		group => zabbix,
		mode => 0640,
		require => File['/etc/zabbix/sql'],
	}

	exec { 'mysql zabbix_server.sql':
		command => '/usr/bin/mysql -u root -h mysql < /etc/zabbix/sql/zabbix_server.sql',
		creates => '/var/lib/mysql/zabbix',
		require => [
			File['zabbix_server.sql'],
			Class['mysql'],
		],
	}

	exec { 'mysql schema.sql':
		command => '/bin/zcat /usr/share/zabbix-server-mysql/schema.sql.gz | /usr/bin/mysql -u root -h mysql zabbix',
		subscribe => Exec['mysql zabbix_server.sql'],
		refreshonly => true,
	}

	exec { 'mysql images.sql':
		command => '/bin/zcat /usr/share/zabbix-server-mysql/images.sql.gz | /usr/bin/mysql -u root -h mysql zabbix',
		subscribe => Exec['mysql schema.sql'],
		refreshonly => true,
	}

	exec { 'mysql data.sql':
		command => '/bin/zcat /usr/share/zabbix-server-mysql/data.sql.gz | /usr/bin/mysql -u root -h mysql zabbix',
		subscribe => Exec['mysql images.sql'],
		refreshonly => true,
	}

	file { 'zabbix-server':
		path => '/etc/default/zabbix-server',
		source => 'puppet:///modules/snmp-manager/zabbix-server',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['zabbix-server-mysql'],
	}

	service { 'zabbix-server':
		ensure => running,
		enable => true,
		require => Package['zabbix-server-mysql'],
		subscribe => [
			File['zabbix_server.conf'],
			Exec['mysql data.sql'],
			File['zabbix-server'],
		],
	}

	package { 'php5-mysql':
		ensure => installed,
	}

	package { 'zabbix-frontend-php':
		ensure => installed,
		require => [
			Service['apache2'],
			Package['php5-mysql'],
		],
	}

	file { 'zabbix:apache2.conf':
		path => '/etc/apache2/sites-available/zabbix.conf',
		ensure => file,
		source => 'puppet:///modules/snmp-manager/apache2.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['apache2'],
	}

	exec { 'a2ensite zabbix':
		command => '/usr/sbin/a2ensite zabbix',
		creates => '/etc/apache2/sites-enabled/zabbix.conf',
		require => File['zabbix:apache2.conf'],
	}

	file { 'zabbix.conf.php':
		path => '/etc/zabbix/zabbix.conf.php',
		source => 'puppet:///modules/snmp-manager/zabbix.conf.php',
		owner => www-data,
		group => zabbix,
		mode => 0440,
		require => Package['zabbix-frontend-php'],
	}

	package { 'snmp':
		ensure => installed,
	}

	file { 'snmp.conf':
		path => '/etc/snmp/snmp.conf',
		source => 'puppet:///modules/snmp-manager/snmp.conf',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['snmp'],
	}

}
