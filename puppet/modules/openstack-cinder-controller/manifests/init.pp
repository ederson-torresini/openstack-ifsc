class openstack-cinder-controller {

	package { 'cinder-api':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	package { 'cinder-scheduler':
		ensure => installed,
		require => [
			Class['mysql'],
			Class['openstack-rabbitmq'],
			Class['openstack-keystone'],
		],
	}

	service { 'cinder-api':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	service { 'cinder-scheduler':
		ensure => running,
		enable => true,
		subscribe => File['cinder.conf'],
	}

	file { '/var/lib/cinder/cinder.sqlite':
		ensure => absent,
	}

	file { '/etc/cinder/sql':
		ensure => directory,
		require => Package['cinder-api'],
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sql':
		path => '/etc/cinder/sql/cinder.sql',
		ensure => file,
		require => File['/etc/cinder/sql'],
		source => 'puppet:///modules/openstack-cinder-controller/cinder.sql',
		owner => root,
		group => cinder,
		mode => 0640,
	}

	exec { '/usr/bin/mysql -uroot < /etc/cinder/sql/cinder.sql':
		creates => '/var/lib/mysql/cinder',
		require => [
			File['cinder.sql'],
			Class['mysql'],
		],
	}

	exec { '/usr/bin/cinder-manage db sync':
		creates => '/var/lib/mysql/cinder/volumes.frm',
		user => 'cinder',
		require => [
			Package['cinder-api'],
			Package['cinder-scheduler'],
			Exec['/usr/bin/mysql -uroot < /etc/cinder/sql/cinder.sql'],
		],
	}

	file { 'cinder-init.sh':
		path => '/usr/local/sbin/cinder-init.sh',
		ensure => file,
		source => 'puppet:///modules/openstack-cinder-controller/cinder-init.sh',
		owner => root,
		group => cinder,
		mode => 0750,
	}

	file { 'cinder.sh:link':
		path => '/etc/cinder/cinder-init.sh',
		ensure => link,
		target => '/usr/local/sbin/cinder-init.sh',
	}

	exec { '/usr/local/sbin/cinder-init.sh':
		subscribe => Exec['/usr/bin/mysql -uroot < /etc/cinder/sql/cinder.sql'],
		refreshonly => true,
	}

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { '/usr/bin/ceph osd pool create volumes 128':
		require => Package['ceph'],
		subscribe => Exec['/usr/local/sbin/cinder-init.sh'],
		refreshonly => true,
	}

    exec { '/usr/bin/ceph osd pool set volumes size 2':
        subscribe => Exec['/usr/bin/ceph osd pool create volumes 128'],
        refreshonly => true,
    }

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { '/usr/bin/ceph osd pool create backups 128':
		require => Package['ceph'],
		subscribe => Exec['/usr/local/sbin/cinder-init.sh'],
		refreshonly => true,
	}

    exec { '/usr/bin/ceph osd pool set backups size 2':
        subscribe => Exec['/usr/bin/ceph osd pool create backups 128'],
        refreshonly => true,
    }

}

