class ceph-radosgw {

	package { 'radosgw':
		ensure => latest,
		require => [
			Package['ceph'],
		],
	}

	package { 'libnss3-tools':
		ensure => latest,
	}

	# Based on https://ceph.com/docs/master/radosgw/config/#add-a-ceph-object-gateway-script: it will be used by Apache2 user (www-data).
	file { 'ceph.client.radosgw.keyring':
		path => '/etc/ceph/ceph.client.radosgw.keyring',
		ensure => file,
		source => 'puppet:///modules/ceph-radosgw/ceph.client.radosgw.keyring',
		owner => root,
		group => www-data,
		mode => 0640,
		require => Package['ceph'],
	}

	# Altough there is a keyring file location in main configuration (ceph.conf), it's for compatibility with Ubuntu 14.04.
	file { 'ceph.client.radosgw.keyring link':
		path => '/var/lib/ceph/radosgw/ceph-radosgw.gateway/keyring',
		ensure => link,
		target => '/etc/ceph/ceph.client.radosgw.keyring',
	}

	exec { 'ceph auth get-or-create client.radosgw.gateway':
		command => '/usr/bin/ceph auth get-or-create client.radosgw.gateway',
		unless => '/usr/bin/ceph auth list | grep -q client.radosgw.gateway',
	}

	exec { 'ceph auth caps radosgw':
		command => '/usr/bin/ceph auth caps client.radosgw.gateway mon \'allow rw\' osd \'allow rwx\'',
		subscribe => Exec['ceph auth get-or-create client.radosgw.gateway'],
		refreshonly => true,
	}

	file { 'radosgw dir':
		path => '/var/lib/ceph/radosgw/ceph-radosgw.gateway',
		ensure => directory,
		require => Package['ceph'],
		owner => root,
		group => root,
		mode => 0700,
	}

	file { 'radosgw done':
		path => '/var/lib/ceph/radosgw/ceph-radosgw.gateway/done',
		ensure => file,
		owner => root,
		group => root,
		mode => 0400,
		require => File['radosgw dir'],
	}

	service { 'radosgw-all-starter':
		ensure => running,
		enable => true,
		require => [
			File['ceph.conf'],
			File['ceph.client.radosgw.keyring'],
			File['ceph.client.radosgw.keyring link'],
			File['radosgw done'],
		],
	}

	# Based on https://ceph.com/docs/master/radosgw/config-ref/#set-a-region to create region with same found in OpenStack/Keystone.
	file { 'ifsc-sj.json':
		path => '/etc/ceph/ifsc-sj.json',
		ensure => file,
		source => 'puppet:///modules/ceph-radosgw/ifsc-sj.json',
		owner => root,
		group => root,
		mode => 0640,
		require => Package['ceph'],
	}

	exec { 'radosgw-admin set region':
		command => '/usr/bin/radosgw-admin region set --infile /etc/ceph/ifsc-sj.json',
		subscribe => File['ifsc-sj.json'],
		refreshonly => true,
	}

	# Based on https://ceph.com/docs/master/radosgw/config-ref/#set-a-region-map
	file { 'ifsc-sj-map.json':
		path => '/etc/ceph/ifsc-sj-map.json',
		ensure => file,
		source => 'puppet:///modules/ceph-radosgw/ifsc-sj-map.json',
		owner => root,
		group => root,
		mode => 0640,
		require => Package['ceph'],
	}

	exec { 'radosgw-admin set region-map':
		command => '/usr/bin/radosgw-admin region-map set --infile /etc/ceph/ifsc-sj-map.json',
		subscribe => [
			Exec['radosgw-admin set region'],
			File['ifsc-sj-map.json'],
		],
		refreshonly => true,
	}

	exec { 'radosgw-admin region default':
		command => '/usr/bin/radosgw-admin region default ifsc-sj',
		subscribe => Exec['radosgw-admin set region-map'],
		refreshonly => true,
	}

	exec { 'radosgw-admin update':
		command => '/usr/bin/radosgw-admin region-map update',
		subscribe => Exec['radosgw-admin set region-map'],
		refreshonly => true,
	}

	# Based on https://ceph.com/docs/master/radosgw/config-ref/#zones to create region with same found in OpenStack/Keystone.
	file { 'ifsc-sj-0.json':
		path => '/etc/ceph/ifsc-sj-0.json',
		ensure => file,
		source => 'puppet:///modules/ceph-radosgw/ifsc-sj-0.json',
		owner => root,
		group => root,
		mode => 0640,
		require => Package['ceph'],
	}

	exec { 'radosgw-admin set zone':
		command => '/usr/bin/radosgw-admin zone set --infile /etc/ceph/ifsc-sj-0.json',
		subscribe => [
			Exec['radosgw-admin update'],
			File['ifsc-sj-0.json'],
		],
		refreshonly => true,
	}

	# Based on https://ceph.com/docs/master/radosgw/keystone/
	file { 'ceph-radosgw-init.sh':
		path => '/usr/local/sbin/ceph-radosgw-init.sh',
		ensure => file,
		source => 'puppet:///modules/ceph-radosgw/ceph-radosgw-init.sh',
		owner => root,
		group => root,
		mode => 0750,
	}

	file { 'ceph-radosgw.sh:link':
		path => '/etc/ceph/ceph-radosgw-init.sh',
		ensure => link,
		target => '/usr/local/sbin/ceph-radosgw-init.sh',
	}

	exec { 'ceph-radosgw-init.sh':
		command => '/usr/local/sbin/ceph-radosgw-init.sh',
		subscribe => File['ceph-radosgw-init.sh'],
		refreshonly => true,
		require => [
			Exec['/usr/local/sbin/keystone-init.sh'],
			Package['ceph'],
		],
	}

	file { 'nss':
		path => '/var/lib/ceph/radosgw/nss',
		ensure => directory,
		owner => root,
		group => root,
		mode => 0750,
		require => Package['ceph'],
	}

	exec { 'nss:ca.pem':
		command => '/usr/bin/openssl x509 -in /etc/keystone/ssl/certs/ca.pem -pubkey | /usr/bin/certutil -d /var/lib/ceph/radosgw/nss -A -n ca -t "TCu,Cu,Tuw"',
		creates => '/var/lib/ceph/radosgw/nss/done',
		require => [
			Package['keystone'],
			File['nss'],
		],
	}

	exec { 'nss:signing_cert.pem':
		command => '/usr/bin/openssl x509 -in /etc/keystone/ssl/certs/signing_cert.pem -pubkey | /usr/bin/certutil -d /var/lib/ceph/radosgw/nss -A -n signing_cert -t "P,P,P"',
		creates => '/var/lib/ceph/radosgw/nss/done',
		require => [
			Package['keystone'],
			File['nss'],
		],
	}

	file { 'nss:done':
		path => '/var/lib/ceph/radosgw/nss/done',
		ensure => file,
		owner => root,
		group => root,
		mode => 0640,
		require => [
			Exec['nss:ca.pem'],
			Exec['nss:signing_cert.pem'],
		],
	}

}
