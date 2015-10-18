class smtp {

	package { 'mailutils':
		ensure => installed,
	}

	package { 'postfix':
		ensure => installed,
	}

	# Made with: openssl req -new -days 365 -nodes -x509 -out postfix.pem -keyout postfix.pem
	file { 'postfix.pem':
		path => '/etc/ssl/certs/postfix.pem',
		ensure => file,
		source => 'puppet:///modules/smtp/postfix.pem',
		owner => root,
		group => postfix,
		mode => 0640,
	}

	file { 'aliases':
		path => '/etc/aliases',
		ensure => file,
		source => 'puppet:///modules/smtp/aliases',
		owner => root,
		group => postfix,
		mode => 0644,
	}

	exec { 'newaliases':
		command => '/usr/bin/newaliases',
		subscribe => File['aliases'],
		refreshonly => true,
	}

	file { 'main.cf':
		path => '/etc/postfix/main.cf',
		ensure => file,
		source => 'puppet:///modules/smtp/main.cf',
		owner => root,
		group => postfix,
		mode => 0644,
		require => Package['postfix'],
	}

	service { 'postfix':
		ensure => running,
		enable => true,
		subscribe => [
			File['postfix.pem'],
			File['aliases'],
			File['main.cf'],
		],
	}

}
