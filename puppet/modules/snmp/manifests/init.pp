class snmp {

	package { 'snmpd':
        ensure => installed,
        before => File['snmpd.conf'],
    }

    service { 'snmpd':
        name => 'snmpd',
        ensure => running,
        enable => true,
        subscribe => File['snmpd.conf'],
    }

    file { 'snmpd.conf':
        path => '/etc/snmp/snmpd.conf',
        ensure => file,
        require => Package['snmpd'],
        source => 'puppet:///modules/snmp/snmpd.conf',
        owner => root,
        group => root,
        mode => 0644,
    }

}

