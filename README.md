openstack-ifsc
==============

The problem to solve: buid a self-service IaaS for IFSC teachers (class activities) and students (remote labs), including template machines running open-source or proprietary software (with networked key).

What we have:
- 4 x HP Z220: 1 x Intel Xeon E3-1225v2, 4 x4 GB, 1 x SATA 1 TB @ 7.2K RPM, 2 x Gigabit Ethernet (Intel 82579LM, em1, and Realtek RTL8169, p5p1).
- 1 x VM (external) for router.
- 2 x D-Link DGS-3100-24 (stacked).

What we'll do:
- 1 router (`roteador`) to control access to hypervisors and make things easier to VMs.
- 1 controller (`openstack0`), which runs the following services: SQL database, message queue, identity, image, object storage, block storage, dashboard and all service controllers (for compute and networking).
- 3 compute nodes (`openstack1`, `openstack2` and `openstack3`) running compute and network nodes.
- As each machine has locally 1 TB (and no RAID!), will be used 800 GB of it for Ceph (http://ceph.com) to gain performance (to test later), availability (test too) and, specially, a common backend for image, object and block storage without any SPOF. It will be 2 replicas of data in the cluster, so we're saying 4 disks x 800 GB / 2 replicas = 1600 GB.

So... why not just use some ready deploy application, like ceph-ceploy, Juju or even puppetlabs-openstack?
- Well, because this is for learning purposes, and maybe one (of more) of these applications will be used in another place, but for now (we think) we need some pain to gain :-)

Installation
------------

Physical Mapping:
- `roteador`, eth0: virtual interface.
- `roteador`, eth1: virtual interface.
- `roteador`, eth2: virtual interface.
- `openstack0`, em1: switch stack, 2:01.
- `openstack1`, em1: switch stack, 2:10.
- `openstack1`, p5p1: switch stack, 2:13.
- `openstack2`, em1: switch stack, 2:19.
- `openstack2`, p5p1: switch stack, 2:21.
- `openstack3`, em1: switch stack, 2:04.
- `openstack3`, p5p1: switch stack, 2:11.

VLANs:
- 448:
  - Services: VMs' external network.
  - Addresses: 200.135.233.0/25.
    - `roteador`, eth2, untagged: .126.
    - `openstack1`, p5p1, untagged: no address.
    - `openstack2`, p5p1, untagged: no address.
    - `openstack3`, p5p1, untagged: no address.
- 449:
  - Services: hypervisors' remote control.
  - Addresses: 200.135.233.192/28.
    - `roteador`, eth1, untagged: .206.
	- `openstack0`, em1, untagged: .200.
    - `openstack1`, em1, untagged: .201.
    - `openstack2`, em1, untagged: .202.
    - `openstack3`, em1, untagged: .203.
- 450:
  - Services: control, centralized database, messages.
  - Addresses: 10.45.0.0/24.
    - `openstack0`, em1, tagged: .200.
    - `openstack1`, em1, tagged: .201.
    - `openstack2`, em1, tagged: .202.
    - `openstack3`, em1, tagged: .203.
- 451:
  - Services: storage.
  - Addressess: 10.45.1.0/24.
    - `openstack0`, em1, tagged: .200.
    - `openstack1`, em1, tagged: .201.
    - `openstack2`, em1, tagged: .202.
    - `openstack3`, em1, tagged: .203.
- 452:
  - Services: tunnel interface for networking service.
  - Addressess: 10.45.2.0/24.
    - `openstack1`, em1, tagged: .201.
    - `openstack2`, em1, tagged: .202.
    - `openstack3`, em1, tagged: .203.

Operating System:
- Distribution: Ubuntu Server 14.04 LTS.
- Partitioning:
  - Primary: /boot, ext4, 100MB.
  - Primary: /, ext4, 10 GB.
  - Primary: PV LVM, remaining disk space.
    - VG `openstack`.
      - LV `ceph`, xfs, 800 GB.

Network and remote access: as the machines will stay out of physical access, the SSH server was installed with the operating system - DNs server was also installed in `openstack0` to make things easier in the beginning. Some files were manually created to do so.

Initial files:
- `roteador`, `/etc/hostname`:
```
roteador
```

- `roteador`, `/etc/hosts`:
```
127.0.0.1	localhost
200.135.233.253	roteador.openstack.sj.ifsc.edu.br	roteador

# For nginx
200.135.233.200	openstack0.openstack.sj.ifsc.edu.br openstack0 puppet dashboard rabbitmq nova-novncproxy swift radosgw snmp-manager
200.135.233.201	openstack1.openstack.sj.ifsc.edu.br openstack1
200.135.233.202	openstack2.openstack.sj.ifsc.edu.br openstack2
200.135.233.203	openstack2.openstack.sj.ifsc.edu.br openstack3

::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `roteador`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# DMZ
auto eth0
iface eth0 inet static
	address 200.135.233.253
	netmask 255.255.255.252
	gateway 200.135.233.254
	dns-search openstack.sj.ifsc.edu.br
	dns-nameservers 200.135.37.72
	dns-nameservers 200.135.37.65

# OpenStack-IFSC: real
auto eth1
iface eth1 inet static
	address 200.135.233.206
	netmask 255.255.255.240

# OpenStack-IFSC: VMs
auto eth2
iface eth2 inet static
	address 200.135.233.126
	netmask 255.255.255.128
```

- `openstack0`, `/etc/hostname`:
```
openstack0
```

- `openstack0`, `/etc/hosts`:
```
127.0.0.1 localhost openstack0.openstack.sj.ifsc.edu.br openstack0

# For Munin
10.45.0.200 openstack0
10.45.0.201 openstack1
10.45.0.202 openstack2
10.45.0.203 openstack3
200.135.233.206 roteador

::1     localhost ip6-localhost ip6-loopback openstack0.openstack.sj.ifsc.edu.br openstack0
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `openstack0`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback
	dns-search openstack.sj.ifsc.edu.br
	dns-nameservers 127.0.0.1
iface lo inet6 loopback

# Onboard interface
auto em1
iface em1 inet manual

# Remote access
auto vlan449
iface vlan449 inet static
	vlan-raw-device em1
	address 200.135.233.200
	netmask 255.255.255.240
	gateway 200.135.233.206

# Management
auto vlan450
iface vlan450 inet static
	vlan-raw-device em1
	address 10.45.0.200
	netmask 255.255.255.0
iface vlan450 inet6 static
    address FC00:0450::200
    netmask 64
    accept_ra 0
    autconf 0
    scope site

# Storage
auto vlan451
iface vlan451 inet static
	vlan-raw-device em1
	address 10.45.1.200
	netmask 255.255.255.0
iface vlan451 inet6 static
    address FC00:0451::200
    netmask 64
    accept_ra 0
    autconf 0
    scope site
```

- `openstack1`, `/etc/hostname`:
```
openstack1
```

- `openstack1`, `/etc/hosts`:
```
127.0.0.1 localhost openstack1.openstack.sj.ifsc.edu.br openstack1

::1     localhost ip6-localhost ip6-loopback openstack1.openstack.sj.ifsc.edu.br openstack1
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `openstack1`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# Onboard interface
auto em1
iface em1 inet manual

# Remote access
auto vlan449
iface vlan449 inet static
	vlan-raw-device em1
	address 200.135.233.201
	netmask 255.255.255.240
	gateway 200.135.233.206

# Management
auto vlan450
iface vlan450 inet static
	vlan-raw-device em1
	address 10.45.0.201
	netmask 255.255.255.0
	dns-search openstack.sj.ifsc.edu.br
	dns-nameservers 10.45.0.200
iface vlan450 inet6 static
	address FC00:0450::201
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Storage
auto vlan451
iface vlan451 inet static
	vlan-raw-device em1
	address 10.45.1.201
	netmask 255.255.255.0
iface vlan451 inet6 static
	address FC00:0451::201
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Tunnel interface
auto vlan452
iface vlan452 inet static
	vlan-raw-device em1
	address 10.45.2.201
	netmask 255.255.255.0
iface vlan452 inet6 static
	address FC00:0452::201
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# VMs
auto p5p1
iface p5p1 inet manual
```

- `openstack2`, `/etc/hostname`:
```
openstack2
```

- `openstack2`, `/etc/hosts`:
```
127.0.0.1 localhost openstack2.openstack.sj.ifsc.edu.br openstack2

::1     localhost ip6-localhost ip6-loopback openstack2.openstack.sj.ifsc.edu.br openstack2
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `openstack2`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# Onboard interface
auto em1
iface em1 inet manual

# Remote access
auto vlan449
iface vlan449 inet static
	vlan-raw-device em1
	address 200.135.233.202
	netmask 255.255.255.240
	gateway 200.135.233.206

# Management
auto vlan450
iface vlan450 inet static
	vlan-raw-device em1
	address 10.45.0.202
	netmask 255.255.255.0
	dns-search openstack.sj.ifsc.edu.br
	dns-nameservers 10.45.0.200
iface vlan450 inet6 static
	address FC00:0450::202
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Storage
auto vlan451
iface vlan451 inet static
	vlan-raw-device em1
	address 10.45.1.202
	netmask 255.255.255.0
iface vlan451 inet6 static
	address FC00:0451::202
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Tunnel interface
auto vlan452
iface vlan452 inet static
	vlan-raw-device em1
	address 10.45.2.202
	netmask 255.255.255.0
iface vlan452 inet6 static
	address FC00:0452::202
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# VMs
auto p5p1
iface p5p1 inet manual
```

- `openstack3`, `/etc/hostname`:
```
openstack3
```

- `openstack3`, `/etc/hosts`:
```
127.0.0.1 localhost openstack3.openstack.sj.ifsc.edu.br openstack3

::1     localhost ip6-localhost ip6-loopback openstack3.openstack.sj.ifsc.edu.br openstack3
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `openstack3`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback
iface lo inet6 loopback

# Onboard interface
auto em1
iface em1 inet manual

# Remote access
auto vlan449
iface vlan449 inet static
	vlan-raw-device em1
	address 200.135.233.203
	netmask 255.255.255.240
	gateway 200.135.233.206

# Management
auto vlan450
iface vlan450 inet static
	vlan-raw-device em1
	address 10.45.0.203
	netmask 255.255.255.0
	dns-search openstack.sj.ifsc.edu.br
	dns-nameservers 10.45.0.200
iface vlan450 inet6 static
	address FC00:0450::203
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Storage
auto vlan451
iface vlan451 inet static
	vlan-raw-device em1
	address 10.45.1.203
	netmask 255.255.255.0
iface vlan451 inet6 static
	address FC00:0451::203
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# Tunnel interface
auto vlan452
iface vlan452 inet static
	vlan-raw-device em1
	address 10.45.2.203
	netmask 255.255.255.0
iface vlan452 inet6 static
	address FC00:0452::203
	netmask 64
	accept_ra 0
	autconf 0
	scope site

# VMs
auto p5p1
iface p5p1 inet manual
```

And, to activate (repeated in all hosts):
```
ifdown -a
ifup -a
aptitude update
aptitude install vlan
ifup -a
```

Uh-oh! Somehow, video card (nVidia) have some unknown issue when used with open-source drive [nouveau](http://nouveau.freedesktop.org/wiki/) (don't ask me why yet :-). Deactivated with file `/etc/modprobe.d/nvidia.conf`:
```
blacklist nvidia
```
and rebooted (I hate to do this, but it's safer to do).

# Puppet
Installed Puppet master in `openstack0`:
```
aptitude install puppetmaster
```
and agents:
```
aptitude install puppet
```

According to https://github.com/puppetlabs/puppet/commit/fc78774, there is an issue running `puppet resource service`. Fixed with:
```
--- /usr/lib/ruby/vendor_ruby/puppet/provider/service/init.rb-original	2014-05-09 11:44:36.553910572 -0300
+++ /usr/lib/ruby/vendor_ruby/puppet/provider/service/init.rb	2014-05-09 00:54:09.275581934 -0300
@@ -46,7 +46,7 @@
     # Prevent puppet failing to get status of the new service introduced
     # by the fix for this (bug https://bugs.launchpad.net/ubuntu/+source/lightdm/+bug/982889)
     # due to puppet's inability to deal with upstart services with instances.
-    excludes += %w{plymouth-ready}
+    excludes += %w{plymouth-ready startpar-bridge}
   end
 
   # List all services of this type.
```

### Putting all together
- Put, in `roteador`, `openstack1`, `openstack2` and `openstack3` to wait for the master:
```
puppet agent --waitforcert 60
puppet agent --test
```
- In the master (`openstack0`):
```
puppet cert sign openstack1.sj.ifsc.edu.br
puppet cert sign openstack2.sj.ifsc.edu.br
puppet cert sign openstack3.sj.ifsc.edu.br
```
- And, finally, in every agent:
```
puppet agent --enable
puppet agent --test
```

## Puppet and git.
Ok, from this time master and agents can communicate. Now, it's time to combine Puppet and git (this project):
- In master:
```
cd /etc
git clone https://github.com/boidacarapreta/openstack-ifsc.git
mv puppet/* openstack-ifsc/
ln -s openstack-ifsc/puppet puppet
```
Because there are many editors, including me (@boidacarapreta), some file have been modified in its modes:
```
chgrp -R git /etc/openstack-ifsc/
chmod -R g+w /etc/openstack-ifsc/
```

## Internal services
NTP, SNMP and even SSH (reconfigured) was installed and configured using puppet. Check the code :-)
