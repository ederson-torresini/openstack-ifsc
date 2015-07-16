class openstack-ceilometer::common {

	package { 'ceilometer-common':
		ensure => installed,
	}

	file { 'ceilometer.conf':
		path => '/etc/ceilometer/ceilometer.conf',
		ensure => file,
		source => 'puppet:///modules/openstack-ceilometer/ceilometer.conf',
		owner => root,
		group => ceilometer,
		mode => 0640,
		require => Package['ceilometer-common'],
	}

	file { '/var/lib/ceilometer/ceilometer.sqlite':
		ensure => absent,
	}

}

class openstack-ceilometer::controller inherits openstack-ceilometer::common {

	package { 'ceilometer-api':
		ensure => installed,
	}

	service { 'ceilometer-api':
		ensure => running,
		enable => true,
		require => Package['ceilometer-api'],
		subscribe => File['ceilometer.conf'],
	}

	package { 'ceilometer-collector':
		ensure => installed,
	}

	service { 'ceilometer-collector':
		ensure => running,
		enable => true,
		require => Package['ceilometer-collector'],
		subscribe => File['ceilometer.conf'],
	}

	package { 'ceilometer-agent-central':
		ensure => installed,
	}

	service { 'ceilometer-agent-central':
		ensure => running,
		enable => true,
		require => Package['ceilometer-agent-central'],
		subscribe => File['ceilometer.conf'],
	}

	package { 'ceilometer-agent-notification':
		ensure => installed,
	}

	service { 'ceilometer-agent-notification':
		ensure => running,
		enable => true,
		require => Package['ceilometer-agent-notification'],
		subscribe => File['ceilometer.conf'],
	}

	package { 'ceilometer-alarm-evaluator':
		ensure => installed,
	}

	service { 'ceilometer-alarm-evaluator':
		ensure => running,
		enable => true,
		require => Package['ceilometer-alarm-evaluator'],
		subscribe => File['ceilometer.conf'],
	}

	package { 'ceilometer-alarm-notifier':
		ensure => installed,
	}

	service { 'ceilometer-alarm-notifier':
		ensure => running,
		enable => true,
		require => Package['ceilometer-alarm-notifier'],
		subscribe => File['ceilometer.conf'],
	}

	file { '/etc/ceilometer/sql':
		ensure => directory,
		require => Package['ceilometer-common'],
		owner => root,
		group => ceilometer,
		mode => 0750,
	}

	file { 'ceilometer.sql':
		path => '/etc/ceilometer/sql/ceilometer.sql',
		ensure => file,
		require => File['/etc/ceilometer/sql'],
		source => 'puppet:///modules/openstack-ceilometer/ceilometer.sql',
		owner => root,
		group => ceilometer,
		mode => 0640,
	}

	exec { 'mysql ceilometer.sql':
		command => '/usr/bin/mysql -u root -h mysql.openstack.sj.ifsc.edu.br < /etc/ceilometer/sql/ceilometer.sql',
		creates => '/var/lib/mysql/ceilometer',
		require => [
			File['ceilometer.sql'],
		],
	}

	# http://docs.openstack.org/developer/ceilometer/install/manual.html
	exec { 'ceilometer-dbsync':
		command => '/usr/bin/ceilometer-dbsync',
		user => 'ceilometer',
		require => [
			Package['ceilometer-common'],
			Exec['mysql ceilometer.sql'],
		],
		subscribe => File['ceilometer.sql'],
		refreshonly => true,
	}

	file { 'ceilometer-init.sh':
		path => '/usr/local/sbin/ceilometer-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-ceilometer/ceilometer-init.sh',
		owner => root,
		group => ceilometer,
		mode => 0750,
	}

	file { 'ceilometer.sh:link':
		path => '/etc/ceilometer/ceilometer-init.sh',
		ensure => link,
		target => '/usr/local/sbin/ceilometer-init.sh',
	}

	exec { 'ceilometer-init.sh':
		command => '/usr/local/sbin/ceilometer-init.sh',
		require => Package['python-keystoneclient'],
		subscribe => File['ceilometer-init.sh'],
		refreshonly => true,
	}

}

class openstack-ceilometer::compute inherits openstack-ceilometer::common {

	package { 'ceilometer-agent-compute':
		ensure => installed,
		require => Package['nova-compute'],
	}

	service { 'ceilometer-agent-compute':
		ensure => running,
		enable => true,
		require => Package['ceilometer-agent-compute'],
	}
	
}
