class ceph-osd-init {

	# Based on http://ceph.com/docs/next/rados/operations/pools/
	exec { '/usr/bin/ceph osd pool set data pgp_num 128':
		require => Package['ceph'],
		creates => '/etc/ceph/done',
	}

	exec { '/usr/bin/ceph osd pool set metadata pgp_num 128':
		require => Package['ceph'],
		creates => '/etc/ceph/done',
	}

	exec { '/usr/bin/ceph osd pool set rbd pgp_num 128':
		require => Package['ceph'],
		creates => '/etc/ceph/done',
	}

	file { 'ceph:done':
		path => '/etc/ceph/done',
		ensure => file,
		owner => root,
		group => root,
		mode => 0440,
		require => [
			Exec['/usr/bin/ceph osd pool set data pgp_num 128'],
			Exec['/usr/bin/ceph osd pool set metadata pgp_num 128'],
			Exec['/usr/bin/ceph osd pool set rbd pgp_num 128'],
		],
	}

}
