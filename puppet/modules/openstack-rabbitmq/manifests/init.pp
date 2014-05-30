class openstack-rabbitmq {

	package { 'rabbitmq-server':
		ensure => installed,
	}

	service { 'rabbitmq-server':
		ensure => running,
		enable => true,
	}

	exec { 'guest:change_password':
		command => '/usr/sbin/rabbitmqctl change_password guest rabbitmq',
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

	file { 'rabbitmq:done':
		path => '/etc/rabbitmq/done',
		ensure => file,
		require => [
			Exec['adduser'],
			Exec['set_user_tags'],
		],
		owner => root,
		group => rabbitmq,
		mode => 0640,
	}

}

