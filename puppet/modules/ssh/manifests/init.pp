class ssh {
	package { 'openssh-server':
		ensure => installed,
		before => File['sshd_config'],
	}

	service { 'sshd':
		name => 'ssh',
		ensure => running,
		enable => true,
		subscribe => File['sshd_config'],
	}

	file { 'sshd_config':
		path => '/etc/ssh/sshd_config',
		ensure => file,
		require => Package['openssh-server'],
		source => 'puppet:///modules/ssh/sshd_config',
		owner => root,
		group => root,
		mode => 0640,
	}
}
