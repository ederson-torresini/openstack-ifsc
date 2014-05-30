class openstack-rabbitmq {

	package { 'rabbitmq-server':
		ensure => installed,
	}

	service { 'rabbitmq-server':
		ensure => running,
		enable => true,
		subscribe => Exec['plugins'],
	}

	exec { 'add_vhost':
		command => '/usr/sbin/rabbitmqctl add_vhost openstack-ifsc',
		require => Package['rabbitmq-server'],
		creates => '/etc/rabbitmq/done',
	}

	exec { 'adduser':
		command => '/usr/sbin/rabbitmqctl add_user rabbitmq rabbitmq',
		require => Package['rabbitmq-server'],
		creates => '/etc/rabbitmq/done',
	}

	exec { 'set_user_tags':
		command => '/usr/sbin/rabbitmqctl set_user_tags rabbitmq administrator',
		require => Exec['adduser'],
		creates => '/etc/rabbitmq/done',
	}

	exec { 'set_permissions':
		command => '/usr/sbin/rabbitmqctl set_permissions -p openstack-ifsc rabbitmq ".*" ".*" ".*"',
		creates => '/etc/rabbitmq/done',
	}

	exec { 'plugins':
		command => '/usr/sbin/rabbitmq-plugins enable rabbitmq_management',
		creates => '/etc/rabbitmq/done',
	}

	file { 'rabbitmqadmin':
		path => '/usr/local/sbin/rabbitmqadmin',
		ensure => file,
		source => 'puppet:///modules/openstack-rabbitmq/rabbitmqadmin',
		owner => root,
		group => rabbitmq,
		mode => 0750,
	}

	file { 'rabbitmq:done':
		path => '/etc/rabbitmq/done',
		ensure => file,
		require => [
			Exec['add_vhost'],
			Exec['adduser'],
			Exec['set_user_tags'],
			Exec['set_permissions'],
			Exec['plugins'],
			File['rabbitmqadmin']
		],
		owner => root,
		group => rabbitmq,
		mode => 0640,
	}

}

