class nginx {

	package { 'nginx':
		ensure => installed,
	}

	# Made with: openssl req -new -days 365 -nodes -x509 -out nginx.pem -keyout nginx.pem
	file { 'nginx.pem':
		path => '/etc/ssl/certs/nginx.pem',
		ensure => file,
		source => 'puppet:///modules/nginx/nginx.pem',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['nginx'],
	}

	file { 'nginx.conf':
		path => '/etc/nginx/nginx.conf',
		ensure => file,
		source => 'puppet:///modules/nginx/nginx.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => [
			Package['nginx'],
			File['nginx.pem'],
			File['senhas'],
		],
	}

	service { 'nginx':
		ensure => running,
		enable => true,
		subscribe => [
			File['nginx.pem'],
			File['nginx.conf'],
		],
	}

}

