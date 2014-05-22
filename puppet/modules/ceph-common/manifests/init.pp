class ceph-common {

	package { 'ceph':
		ensure => installed,
	}

	file { 'ceph.conf':
		path => '/etc/ceph/ceph.conf',
		ensure => file,
		require => Package['ceph'],
		source => 'puppet:///modules/ceph-common/ceph.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

}
