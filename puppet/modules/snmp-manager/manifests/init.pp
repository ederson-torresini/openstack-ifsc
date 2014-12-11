class snmp-manager {

	package { 'snmp':
		ensure => installed,
	}

	package { 'munin':
		ensure => installed,
		require => [
			Class['snmp-agent'],
		],
	}

	file { 'snmp_communities':
		path => '/etc/munin/plugin-conf.d/snmp_communities',
		ensure => file,
		source => 'puppet:///modules/snmp-manager/snmp_communities',
		owner => root,
		group => munin,
		mode => 0640,
		require => Package['munin'],
	}

	file { 'munin-node.conf':
		path => '/etc/munin/munin-node.conf',
		ensure => file,
		source => 'puppet:///modules/snmp-manager/munin-node.conf',
		owner => root,
		group => munin,
		mode => 0640,
		require => Package['munin'],
	}

	file { 'munin.conf':
		path => '/etc/munin/munin.conf',
		ensure => file,
		source => 'puppet:///modules/snmp-manager/munin.conf',
		owner => root,
		group => munin,
		mode => 0640,
		require => Package['munin'],
	}

	service { 'munin-node':
		ensure => running,
		enable => true,
		subscribe => [
			File['snmp_communities'],
			File['munin-node.conf'],
			File['munin.conf'],
		],
	}

	file { 'site munin':
		path => '/etc/apache2/sites-available/munin.conf',
		ensure => file,
		source => 'puppet:///modules/snmp-manager/apache2.conf',
		owner => root,
		group => www-data,
		mode => 0640,
		require => [
			Package['apache2'],
		],
	}

	exec { 'a2ensite munin':
		command => '/usr/sbin/a2ensite munin',
		subscribe => [
			File['site munin'],
		],
		creates => '/etc/apache2/sites-enabled/munin.conf',
	}

	exec { 'a2disconf munin':
		command => '/usr/sbin/a2disconf munin',
		subscribe => Exec['a2ensite munin'],
		refreshonly => true,
	}

	file { '/etc/munin/plugins/snmp_openstack0_cpuload':
		path => '/etc/munin/plugins/snmp_openstack0_cpuload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__cpuload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_df':
		path => '/etc/munin/plugins/snmp_openstack0_df',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_df_ram':
		path => '/etc/munin/plugins/snmp_openstack0_df_ram',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df_ram',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_1':
		path => '/etc/munin/plugins/snmp_openstack0_if_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_2':
		path => '/etc/munin/plugins/snmp_openstack0_if_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_3':
		path => '/etc/munin/plugins/snmp_openstack0_if_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_4':
		path => '/etc/munin/plugins/snmp_openstack0_if_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_5':
		path => '/etc/munin/plugins/snmp_openstack0_if_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_6':
		path => '/etc/munin/plugins/snmp_openstack0_if_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_7':
		path => '/etc/munin/plugins/snmp_openstack0_if_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_8':
		path => '/etc/munin/plugins/snmp_openstack0_if_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_9':
		path => '/etc/munin/plugins/snmp_openstack0_if_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_10':
		path => '/etc/munin/plugins/snmp_openstack0_if_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_11':
		path => '/etc/munin/plugins/snmp_openstack0_if_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_12':
		path => '/etc/munin/plugins/snmp_openstack0_if_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_13':
		path => '/etc/munin/plugins/snmp_openstack0_if_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_14':
		path => '/etc/munin/plugins/snmp_openstack0_if_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_15':
		path => '/etc/munin/plugins/snmp_openstack0_if_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_16':
		path => '/etc/munin/plugins/snmp_openstack0_if_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_17':
		path => '/etc/munin/plugins/snmp_openstack0_if_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_18':
		path => '/etc/munin/plugins/snmp_openstack0_if_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_19':
		path => '/etc/munin/plugins/snmp_openstack0_if_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_20':
		path => '/etc/munin/plugins/snmp_openstack0_if_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_1':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_2':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_3':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_4':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_5':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_6':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_7':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_8':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_9':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_10':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_11':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_12':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_13':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_14':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_15':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_16':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_17':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_18':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_19':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_err_20':
		path => '/etc/munin/plugins/snmp_openstack0_if_err_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_if_multi':
		path => '/etc/munin/plugins/snmp_openstack0_if_multi',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_multi',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_load':
		path => '/etc/munin/plugins/snmp_openstack0_load',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__load',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_memory':
		path => '/etc/munin/plugins/snmp_openstack0_memory',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__memory',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_netstat':
		path => '/etc/munin/plugins/snmp_openstack0_netstat',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__netstat',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_processes':
		path => '/etc/munin/plugins/snmp_openstack0_processes',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__processes',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_swap':
		path => '/etc/munin/plugins/snmp_openstack0_swap',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__swap',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_uptime':
		path => '/etc/munin/plugins/snmp_openstack0_uptime',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__uptime',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_users':
		path => '/etc/munin/plugins/snmp_openstack0_users',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__users',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_winload':
		path => '/etc/munin/plugins/snmp_openstack0_winload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack0_winmem':
		path => '/etc/munin/plugins/snmp_openstack0_winmem',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winmem',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_cpuload':
		path => '/etc/munin/plugins/snmp_openstack1_cpuload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__cpuload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_df':
		path => '/etc/munin/plugins/snmp_openstack1_df',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_df_ram':
		path => '/etc/munin/plugins/snmp_openstack1_df_ram',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df_ram',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_1':
		path => '/etc/munin/plugins/snmp_openstack1_if_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_2':
		path => '/etc/munin/plugins/snmp_openstack1_if_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_3':
		path => '/etc/munin/plugins/snmp_openstack1_if_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_4':
		path => '/etc/munin/plugins/snmp_openstack1_if_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_5':
		path => '/etc/munin/plugins/snmp_openstack1_if_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_6':
		path => '/etc/munin/plugins/snmp_openstack1_if_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_7':
		path => '/etc/munin/plugins/snmp_openstack1_if_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_8':
		path => '/etc/munin/plugins/snmp_openstack1_if_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_9':
		path => '/etc/munin/plugins/snmp_openstack1_if_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_10':
		path => '/etc/munin/plugins/snmp_openstack1_if_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_11':
		path => '/etc/munin/plugins/snmp_openstack1_if_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_12':
		path => '/etc/munin/plugins/snmp_openstack1_if_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_13':
		path => '/etc/munin/plugins/snmp_openstack1_if_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_14':
		path => '/etc/munin/plugins/snmp_openstack1_if_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_15':
		path => '/etc/munin/plugins/snmp_openstack1_if_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_16':
		path => '/etc/munin/plugins/snmp_openstack1_if_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_17':
		path => '/etc/munin/plugins/snmp_openstack1_if_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_18':
		path => '/etc/munin/plugins/snmp_openstack1_if_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_19':
		path => '/etc/munin/plugins/snmp_openstack1_if_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_20':
		path => '/etc/munin/plugins/snmp_openstack1_if_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_1':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_2':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_3':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_4':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_5':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_6':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_7':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_8':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_9':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_10':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_11':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_12':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_13':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_14':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_15':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_16':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_17':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_18':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_19':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_err_20':
		path => '/etc/munin/plugins/snmp_openstack1_if_err_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_if_multi':
		path => '/etc/munin/plugins/snmp_openstack1_if_multi',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_multi',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_load':
		path => '/etc/munin/plugins/snmp_openstack1_load',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__load',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_memory':
		path => '/etc/munin/plugins/snmp_openstack1_memory',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__memory',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_netstat':
		path => '/etc/munin/plugins/snmp_openstack1_netstat',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__netstat',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_processes':
		path => '/etc/munin/plugins/snmp_openstack1_processes',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__processes',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_swap':
		path => '/etc/munin/plugins/snmp_openstack1_swap',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__swap',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_uptime':
		path => '/etc/munin/plugins/snmp_openstack1_uptime',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__uptime',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_users':
		path => '/etc/munin/plugins/snmp_openstack1_users',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__users',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_winload':
		path => '/etc/munin/plugins/snmp_openstack1_winload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack1_winmem':
		path => '/etc/munin/plugins/snmp_openstack1_winmem',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winmem',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_cpuload':
		path => '/etc/munin/plugins/snmp_openstack2_cpuload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__cpuload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_df':
		path => '/etc/munin/plugins/snmp_openstack2_df',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_df_ram':
		path => '/etc/munin/plugins/snmp_openstack2_df_ram',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df_ram',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_1':
		path => '/etc/munin/plugins/snmp_openstack2_if_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_2':
		path => '/etc/munin/plugins/snmp_openstack2_if_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_3':
		path => '/etc/munin/plugins/snmp_openstack2_if_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_4':
		path => '/etc/munin/plugins/snmp_openstack2_if_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_5':
		path => '/etc/munin/plugins/snmp_openstack2_if_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_6':
		path => '/etc/munin/plugins/snmp_openstack2_if_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_7':
		path => '/etc/munin/plugins/snmp_openstack2_if_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_8':
		path => '/etc/munin/plugins/snmp_openstack2_if_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_9':
		path => '/etc/munin/plugins/snmp_openstack2_if_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_10':
		path => '/etc/munin/plugins/snmp_openstack2_if_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_11':
		path => '/etc/munin/plugins/snmp_openstack2_if_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_12':
		path => '/etc/munin/plugins/snmp_openstack2_if_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_13':
		path => '/etc/munin/plugins/snmp_openstack2_if_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_14':
		path => '/etc/munin/plugins/snmp_openstack2_if_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_15':
		path => '/etc/munin/plugins/snmp_openstack2_if_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_16':
		path => '/etc/munin/plugins/snmp_openstack2_if_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_17':
		path => '/etc/munin/plugins/snmp_openstack2_if_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_18':
		path => '/etc/munin/plugins/snmp_openstack2_if_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_19':
		path => '/etc/munin/plugins/snmp_openstack2_if_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_20':
		path => '/etc/munin/plugins/snmp_openstack2_if_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_1':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_2':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_3':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_4':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_5':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_6':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_7':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_8':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_9':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_10':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_11':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_12':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_13':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_14':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_15':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_16':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_17':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_18':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_19':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_err_20':
		path => '/etc/munin/plugins/snmp_openstack2_if_err_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_if_multi':
		path => '/etc/munin/plugins/snmp_openstack2_if_multi',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_multi',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_load':
		path => '/etc/munin/plugins/snmp_openstack2_load',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__load',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_memory':
		path => '/etc/munin/plugins/snmp_openstack2_memory',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__memory',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_netstat':
		path => '/etc/munin/plugins/snmp_openstack2_netstat',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__netstat',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_processes':
		path => '/etc/munin/plugins/snmp_openstack2_processes',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__processes',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_swap':
		path => '/etc/munin/plugins/snmp_openstack2_swap',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__swap',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_uptime':
		path => '/etc/munin/plugins/snmp_openstack2_uptime',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__uptime',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_users':
		path => '/etc/munin/plugins/snmp_openstack2_users',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__users',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_winload':
		path => '/etc/munin/plugins/snmp_openstack2_winload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack2_winmem':
		path => '/etc/munin/plugins/snmp_openstack2_winmem',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winmem',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_cpuload':
		path => '/etc/munin/plugins/snmp_openstack3_cpuload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__cpuload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_df':
		path => '/etc/munin/plugins/snmp_openstack3_df',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_df_ram':
		path => '/etc/munin/plugins/snmp_openstack3_df_ram',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df_ram',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_1':
		path => '/etc/munin/plugins/snmp_openstack3_if_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_2':
		path => '/etc/munin/plugins/snmp_openstack3_if_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_3':
		path => '/etc/munin/plugins/snmp_openstack3_if_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_4':
		path => '/etc/munin/plugins/snmp_openstack3_if_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_5':
		path => '/etc/munin/plugins/snmp_openstack3_if_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_6':
		path => '/etc/munin/plugins/snmp_openstack3_if_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_7':
		path => '/etc/munin/plugins/snmp_openstack3_if_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_8':
		path => '/etc/munin/plugins/snmp_openstack3_if_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_9':
		path => '/etc/munin/plugins/snmp_openstack3_if_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_10':
		path => '/etc/munin/plugins/snmp_openstack3_if_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_11':
		path => '/etc/munin/plugins/snmp_openstack3_if_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_12':
		path => '/etc/munin/plugins/snmp_openstack3_if_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_13':
		path => '/etc/munin/plugins/snmp_openstack3_if_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_14':
		path => '/etc/munin/plugins/snmp_openstack3_if_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_15':
		path => '/etc/munin/plugins/snmp_openstack3_if_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_16':
		path => '/etc/munin/plugins/snmp_openstack3_if_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_17':
		path => '/etc/munin/plugins/snmp_openstack3_if_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_18':
		path => '/etc/munin/plugins/snmp_openstack3_if_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_19':
		path => '/etc/munin/plugins/snmp_openstack3_if_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_20':
		path => '/etc/munin/plugins/snmp_openstack3_if_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_1':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_2':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_3':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_4':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_5':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_6':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_7':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_8':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_9':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_10':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_11':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_12':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_13':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_14':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_15':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_16':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_17':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_18':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_19':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_err_20':
		path => '/etc/munin/plugins/snmp_openstack3_if_err_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_if_multi':
		path => '/etc/munin/plugins/snmp_openstack3_if_multi',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_multi',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_load':
		path => '/etc/munin/plugins/snmp_openstack3_load',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__load',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_memory':
		path => '/etc/munin/plugins/snmp_openstack3_memory',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__memory',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_netstat':
		path => '/etc/munin/plugins/snmp_openstack3_netstat',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__netstat',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_processes':
		path => '/etc/munin/plugins/snmp_openstack3_processes',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__processes',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_swap':
		path => '/etc/munin/plugins/snmp_openstack3_swap',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__swap',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_uptime':
		path => '/etc/munin/plugins/snmp_openstack3_uptime',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__uptime',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_users':
		path => '/etc/munin/plugins/snmp_openstack3_users',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__users',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_winload':
		path => '/etc/munin/plugins/snmp_openstack3_winload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_openstack3_winmem':
		path => '/etc/munin/plugins/snmp_openstack3_winmem',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winmem',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_cpuload':
		path => '/etc/munin/plugins/snmp_roteador_cpuload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__cpuload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_df':
		path => '/etc/munin/plugins/snmp_roteador_df',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_df_ram':
		path => '/etc/munin/plugins/snmp_roteador_df_ram',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__df_ram',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_1':
		path => '/etc/munin/plugins/snmp_roteador_if_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_2':
		path => '/etc/munin/plugins/snmp_roteador_if_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_3':
		path => '/etc/munin/plugins/snmp_roteador_if_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_4':
		path => '/etc/munin/plugins/snmp_roteador_if_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_5':
		path => '/etc/munin/plugins/snmp_roteador_if_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_6':
		path => '/etc/munin/plugins/snmp_roteador_if_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_7':
		path => '/etc/munin/plugins/snmp_roteador_if_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_8':
		path => '/etc/munin/plugins/snmp_roteador_if_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_9':
		path => '/etc/munin/plugins/snmp_roteador_if_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_10':
		path => '/etc/munin/plugins/snmp_roteador_if_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_11':
		path => '/etc/munin/plugins/snmp_roteador_if_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_12':
		path => '/etc/munin/plugins/snmp_roteador_if_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_13':
		path => '/etc/munin/plugins/snmp_roteador_if_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_14':
		path => '/etc/munin/plugins/snmp_roteador_if_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_15':
		path => '/etc/munin/plugins/snmp_roteador_if_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_16':
		path => '/etc/munin/plugins/snmp_roteador_if_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_17':
		path => '/etc/munin/plugins/snmp_roteador_if_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_18':
		path => '/etc/munin/plugins/snmp_roteador_if_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_19':
		path => '/etc/munin/plugins/snmp_roteador_if_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_20':
		path => '/etc/munin/plugins/snmp_roteador_if_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_1':
		path => '/etc/munin/plugins/snmp_roteador_if_err_1',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_2':
		path => '/etc/munin/plugins/snmp_roteador_if_err_2',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_3':
		path => '/etc/munin/plugins/snmp_roteador_if_err_3',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_4':
		path => '/etc/munin/plugins/snmp_roteador_if_err_4',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_5':
		path => '/etc/munin/plugins/snmp_roteador_if_err_5',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_6':
		path => '/etc/munin/plugins/snmp_roteador_if_err_6',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_7':
		path => '/etc/munin/plugins/snmp_roteador_if_err_7',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_8':
		path => '/etc/munin/plugins/snmp_roteador_if_err_8',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_9':
		path => '/etc/munin/plugins/snmp_roteador_if_err_9',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_10':
		path => '/etc/munin/plugins/snmp_roteador_if_err_10',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_11':
		path => '/etc/munin/plugins/snmp_roteador_if_err_11',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_12':
		path => '/etc/munin/plugins/snmp_roteador_if_err_12',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_13':
		path => '/etc/munin/plugins/snmp_roteador_if_err_13',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_14':
		path => '/etc/munin/plugins/snmp_roteador_if_err_14',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_15':
		path => '/etc/munin/plugins/snmp_roteador_if_err_15',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_16':
		path => '/etc/munin/plugins/snmp_roteador_if_err_16',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_17':
		path => '/etc/munin/plugins/snmp_roteador_if_err_17',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_18':
		path => '/etc/munin/plugins/snmp_roteador_if_err_18',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_19':
		path => '/etc/munin/plugins/snmp_roteador_if_err_19',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_err_20':
		path => '/etc/munin/plugins/snmp_roteador_if_err_20',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_err_',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_if_multi':
		path => '/etc/munin/plugins/snmp_roteador_if_multi',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__if_multi',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_load':
		path => '/etc/munin/plugins/snmp_roteador_load',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__load',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_memory':
		path => '/etc/munin/plugins/snmp_roteador_memory',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__memory',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_netstat':
		path => '/etc/munin/plugins/snmp_roteador_netstat',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__netstat',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_processes':
		path => '/etc/munin/plugins/snmp_roteador_processes',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__processes',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_swap':
		path => '/etc/munin/plugins/snmp_roteador_swap',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__swap',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_uptime':
		path => '/etc/munin/plugins/snmp_roteador_uptime',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__uptime',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_users':
		path => '/etc/munin/plugins/snmp_roteador_users',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__users',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_winload':
		path => '/etc/munin/plugins/snmp_roteador_winload',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winload',
		require => Package['munin'],
	}

	file { '/etc/munin/plugins/snmp_roteador_winmem':
		path => '/etc/munin/plugins/snmp_roteador_winmem',
		ensure => link,
		target => '/usr/share/munin/plugins/snmp__winmem',
		require => Package['munin'],
	}

}

