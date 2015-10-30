class cron {

	package { 'cron':
		ensure => latest,
	}

	file { 'crontab':
		path => '/etc/crontab',
		source => 'puppet:///modules/cron/crontab',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['cron'],
	}

	service { 'cron':
		ensure => running,
		enable => true,
		subscribe => File['crontab'],
	}

}
