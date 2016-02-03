class openstack-common {

	package{ 'git':
		ensure => installed,
	}

	package { 'mysql-client':
		ensure => installed,
	}

	package { 'python-mysqldb':
		ensure => installed,
	}

	package { 'python-setuptools':
		ensure => installed,
	}

	package { 'python-pip':
		ensure => installed,
	}

	package { 'python-keystoneclient':
		ensure => installed,
	}

	package { 'python-glanceclient':
		ensure => installed,
	}

	package { 'python-novaclient':
		ensure => installed,
	}

	package { 'qemu-utils':
		ensure => installed,
	}

	package { 'python-neutronclient':
		ensure => installed,
	}

	package { 'python-cinderclient':
		ensure => installed,
	}

	package { 'python-swiftclient':
		ensure => installed,
	}

	package { 'python-heatclient':
		ensure => installed,
	}

	package { 'python-ceilometerclient':
		ensure => installed,
	}

	package { 'python-troveclient':
		ensure => installed,
	}

	package { 'python-openstackclient':
		ensure => installed,
	}

	exec { 'ethtool:em1-rx-checksumming':
    command => '/sbin/ethtool -K em1 rx-checksumming on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksumming':
    command => '/sbin/ethtool -K em1 tx-checksumming on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksum-ipv4':
    command => '/sbin/ethtool -K em1 tx-checksum-ipv4 on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksum-ip-generic':
    command => '/sbin/ethtool -K em1 tx-checksum-ip-generic on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksum-ipv6':
    command => '/sbin/ethtool -K em1 tx-checksum-ipv6 on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksum-fcoe-crc':
    command => '/sbin/ethtool -K em1 tx-checksum-fcoe-crc on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-checksum-sctp':
    command => '/sbin/ethtool -K em1 tx-checksum-sctp on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-scatter-gather':
    command => '/sbin/ethtool -K em1 scatter-gather on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-scatter-gather':
    command => '/sbin/ethtool -K em1 tx-scatter-gather on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-scatter-gather-fraglist':
    command => '/sbin/ethtool -K em1 tx-scatter-gather-fraglist on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tcp-segmentation-offload':
    command => '/sbin/ethtool -K em1 tcp-segmentation-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-tcp-segmentation':
    command => '/sbin/ethtool -K em1 tx-tcp-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-tcp-ecn-segmentation':
    command => '/sbin/ethtool -K em1 tx-tcp-ecn-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-tcp6-segmentation':
    command => '/sbin/ethtool -K em1 tx-tcp6-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-udp-fragmentation-offload':
    command => '/sbin/ethtool -K em1 udp-fragmentation-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-generic-segmentation-offload':
    command => '/sbin/ethtool -K em1 generic-segmentation-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-generic-receive-offload':
    command => '/sbin/ethtool -K em1 generic-receive-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-large-receive-offload':
    command => '/sbin/ethtool -K em1 large-receive-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-vlan-offload':
    command => '/sbin/ethtool -K em1 rx-vlan-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-vlan-offload':
    command => '/sbin/ethtool -K em1 tx-vlan-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-ntuple-filters':
    command => '/sbin/ethtool -K em1 ntuple-filters on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-receive-hashing':
    command => '/sbin/ethtool -K em1 receive-hashing on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-highdma':
    command => '/sbin/ethtool -K em1 highdma on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-vlan-filter':
    command => '/sbin/ethtool -K em1 rx-vlan-filter on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-vlan-challenged':
    command => '/sbin/ethtool -K em1 vlan-challenged on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-lockless':
    command => '/sbin/ethtool -K em1 tx-lockless on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-netns-local':
    command => '/sbin/ethtool -K em1 netns-local on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-gso-robust':
    command => '/sbin/ethtool -K em1 tx-gso-robust on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-fcoe-segmentation':
    command => '/sbin/ethtool -K em1 tx-fcoe-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-gre-segmentation':
    command => '/sbin/ethtool -K em1 tx-gre-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-ipip-segmentation':
    command => '/sbin/ethtool -K em1 tx-ipip-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-sit-segmentation':
    command => '/sbin/ethtool -K em1 tx-sit-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-udp_tnl-segmentation':
    command => '/sbin/ethtool -K em1 tx-udp_tnl-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-mpls-segmentation':
    command => '/sbin/ethtool -K em1 tx-mpls-segmentation on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-fcoe-mtu':
    command => '/sbin/ethtool -K em1 fcoe-mtu on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-nocache-copy':
    command => '/sbin/ethtool -K em1 tx-nocache-copy on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-loopback':
    command => '/sbin/ethtool -K em1 loopback on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-fcs':
    command => '/sbin/ethtool -K em1 rx-fcs on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-all':
    command => '/sbin/ethtool -K em1 rx-all on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-tx-vlan-stag-hw-insert':
    command => '/sbin/ethtool -K em1 tx-vlan-stag-hw-insert on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-vlan-stag-hw-parse':
    command => '/sbin/ethtool -K em1 rx-vlan-stag-hw-parse on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-rx-vlan-stag-filter':
    command => '/sbin/ethtool -K em1 rx-vlan-stag-filter on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:em1-l2-fwd-offload':
    command => '/sbin/ethtool -K em1 l2-fwd-offload on',
    onlyif => '/sbin/ip addr show em1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-checksumming':
    command => '/sbin/ethtool -K p5p1 rx-checksumming on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksumming':
    command => '/sbin/ethtool -K p5p1 tx-checksumming on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksum-ipv4':
    command => '/sbin/ethtool -K p5p1 tx-checksum-ipv4 on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksum-ip-generic':
    command => '/sbin/ethtool -K p5p1 tx-checksum-ip-generic on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksum-ipv6':
    command => '/sbin/ethtool -K p5p1 tx-checksum-ipv6 on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksum-fcoe-crc':
    command => '/sbin/ethtool -K p5p1 tx-checksum-fcoe-crc on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-checksum-sctp':
    command => '/sbin/ethtool -K p5p1 tx-checksum-sctp on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-scatter-gather':
    command => '/sbin/ethtool -K p5p1 scatter-gather on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-scatter-gather':
    command => '/sbin/ethtool -K p5p1 tx-scatter-gather on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-scatter-gather-fraglist':
    command => '/sbin/ethtool -K p5p1 tx-scatter-gather-fraglist on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tcp-segmentation-offload':
    command => '/sbin/ethtool -K p5p1 tcp-segmentation-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-tcp-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-tcp-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-tcp-ecn-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-tcp-ecn-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-tcp6-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-tcp6-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-udp-fragmentation-offload':
    command => '/sbin/ethtool -K p5p1 udp-fragmentation-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-generic-segmentation-offload':
    command => '/sbin/ethtool -K p5p1 generic-segmentation-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-generic-receive-offload':
    command => '/sbin/ethtool -K p5p1 generic-receive-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-large-receive-offload':
    command => '/sbin/ethtool -K p5p1 large-receive-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-vlan-offload':
    command => '/sbin/ethtool -K p5p1 rx-vlan-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-vlan-offload':
    command => '/sbin/ethtool -K p5p1 tx-vlan-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-ntuple-filters':
    command => '/sbin/ethtool -K p5p1 ntuple-filters on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-receive-hashing':
    command => '/sbin/ethtool -K p5p1 receive-hashing on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-highdma':
    command => '/sbin/ethtool -K p5p1 highdma on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-vlan-filter':
    command => '/sbin/ethtool -K p5p1 rx-vlan-filter on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-vlan-challenged':
    command => '/sbin/ethtool -K p5p1 vlan-challenged on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-lockless':
    command => '/sbin/ethtool -K p5p1 tx-lockless on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-netns-local':
    command => '/sbin/ethtool -K p5p1 netns-local on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-gso-robust':
    command => '/sbin/ethtool -K p5p1 tx-gso-robust on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-fcoe-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-fcoe-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-gre-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-gre-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-ipip-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-ipip-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-sit-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-sit-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-udp_tnl-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-udp_tnl-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-mpls-segmentation':
    command => '/sbin/ethtool -K p5p1 tx-mpls-segmentation on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-fcoe-mtu':
    command => '/sbin/ethtool -K p5p1 fcoe-mtu on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-nocache-copy':
    command => '/sbin/ethtool -K p5p1 tx-nocache-copy on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-loopback':
    command => '/sbin/ethtool -K p5p1 loopback on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-fcs':
    command => '/sbin/ethtool -K p5p1 rx-fcs on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-all':
    command => '/sbin/ethtool -K p5p1 rx-all on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-tx-vlan-stag-hw-insert':
    command => '/sbin/ethtool -K p5p1 tx-vlan-stag-hw-insert on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-vlan-stag-hw-parse':
    command => '/sbin/ethtool -K p5p1 rx-vlan-stag-hw-parse on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-rx-vlan-stag-filter':
    command => '/sbin/ethtool -K p5p1 rx-vlan-stag-filter on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

  exec { 'ethtool:p5p1-l2-fwd-offload':
    command => '/sbin/ethtool -K p5p1 l2-fwd-offload on',
    onlyif => '/sbin/ip addr show p5p1',
    schedule => daily,
  }

}
