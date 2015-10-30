class keepalived {

	file { 'sysctl-keepalived.conf':
		path => '/etc/sysctl-keepalived.conf',
		source => 'puppet:///modules/keepalived/sysctl-keepalived.conf',
		owner => root,
		group => root,
		mode => 0644,
	}

	exec { 'sysctl:sysctl-keepalived.conf':
		command => '/sbin/sysctl -p /etc/sysctl-keepalived.conf',
		require => File['sysctl-keepalived.conf'],
	}

	package { 'keepalived':
		ensure => latest,
	}

	$source = $hostname ? {
		'openstack0' => 'puppet:///modules/keepalived/keepalived-openstack0.conf',
		'openstack1' => 'puppet:///modules/keepalived/keepalived-openstack1.conf',
		'openstack2' => 'puppet:///modules/keepalived/keepalived-openstack2.conf',
		'openstack3' => 'puppet:///modules/keepalived/keepalived-openstack3.conf',
	}

	file { 'keepalived.conf':
		path => '/etc/keepalived/keepalived.conf',
		source => $source,
		owner => root,
		group => root,
		mode => 0644,
		require => Package['keepalived'],
	}

	service { 'keepalived':
		ensure => running,
		enable => true,
		require => Exec['sysctl:sysctl-keepalived.conf'],
		subscribe => File['keepalived.conf'],
	}

}
