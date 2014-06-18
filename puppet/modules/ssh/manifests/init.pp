class ssh {

	package { 'openssh-client':
		ensure => installed,
	}

	package { 'openssh-server':
		ensure => installed,
	}

	file { 'ssh_config':
		path => '/etc/ssh/ssh_config',
		ensure => file,
		source => 'puppet:///modules/ssh/ssh_config',
		owner => root,
		group => root,
		mode => 0644,
		require => Package['openssh-client'],
	}

	file { 'sshd_config':
		path => '/etc/ssh/sshd_config',
		ensure => file,
		source => 'puppet:///modules/ssh/sshd_config',
		owner => root,
		group => root,
		mode => 0640,
		require => Package['openssh-server'],
	}

	service { 'ssh':
		ensure => running,
		enable => true,
		subscribe => File['sshd_config'],
	}


}

