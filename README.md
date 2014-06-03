openstack-ifsc
==============

The problem to solve: buid a self-service IaaS for IFSC teachers (class activities) and students (remote labs), including template machines running open-source or proprietary software (with networked key).

What we have:
-  3 x HP Z220: 1 x Intel Xeon E3-1225v2, 4 x4 GB, 1 x SATA 1 TB @ 7.2K RPM, 2 x Gigabit Ethernet (Intel 82579LM, em1,  and Realtek RTL8169, p5p1).
- 2 x D-Link DGS-3100-24 (stacked).

What we'll do:
- 1 controller, which runs the following services: SQL database, message queue, identity, image, object storage, block storage, dashboard and all service controllers (for compute and networking).
- 2 compute nodes running: compute and network nodes.
- As each machine has locally  1 TB (and no RAID!), will be used 800 GB of it for Ceph (http://ceph.com) to gain performance (to test later), availability (test too) and, specially, a common backend for image, object and block storage without any SPOF. It will be 2 replicas of data in the cluster, so we're saying 3 disks x 800 GB / 2 replicas = 1200 GB.

Installation
------------

Physical Mapping:
* `openstack0`, em1: switch stack, 2:01
* `openstack0`, p5p1: switch stack, 2:11
* `openstack1`, em1: switch stack, 2:10
* `openstack1`, p5p1: switch stack, 2:13
* `openstack2`, em1: switch stack, 2:19
* `openstack2`, p5p1: switch stack, 2:21

VLANs:
- 001 (default VLAN):
  - Services: remote control (em1) and VMs networks (p5p1).
  - Addresses: 172.18.3.0/24 (http://wiki.sj.ifsc.edu.br/wiki/index.php/Faixa_172.18.3.0).
    - `openstack0`, em1, untagged: .200.
    - `openstack0`, p5p1, untagged: no address.
    - `openstack1`, em1, untagged: .201.
    - `openstack1`, p5p1, untagged: no address.
    - `openstack2`, em1, untagged: .202.
    - `openstack2`, p5p1, untagged: no address.
- 450:
  - Services: control, centralized database, messages.
  - Addresses: 10.45.0.0/24.
    - `openstack0`, em1, tagged: .200.
    - `openstack1`, em1, tagged: .201.
    - `openstack2`, em1, tagged: .202.
- 451:
  - Services: storage.
  - Addressess: 10.45.1.0/24.
    - `openstack0`, em1, tagged: .200.
    - `openstack1`, em1, tagged: .201.
    - `openstack2`, em1, tagged: .202.

Operating System:
- Distribution: Ubuntu Server 14.04 LTS.
- Partitioning:
  - Primary: /boot, ext4, 100MB.
  - Primary: /, ext4, 10 GB.
  - Primary: PV LVM, remaining disk space.
    - VG `openstack`.
      - LV `swap`, swap, 1 GB.
      - LV `ceph`, xfs, 800 GB.

Local users: `boidacarapreta` and `turnes`, both with primary group `git` and default configuration.

Network and remote access: as the machines will stay out of physical access, the SSH server was installed with the operating system - DNs server was also installed in `openstack0` to make things easier in the beginning. Some files were manually created to do so.

Initial files:
- `openstack0`, `/etc/hostname`:
```
openstack0
```

- `openstack0`, `/etc/hosts`:
```
127.0.0.1 localhost openstack0.openstack.sj.ifsc.edu.br openstack0

::1     localhost ip6-localhost ip6-loopback openstack0.openstack.sj.ifsc.edu.br openstack0
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

- `openstack0`, `/etc/network/interfaces`:
```
# Loopback
auto lo
iface lo inet loopback

# Remote access
auto em1
iface em1 inet static
    address 172.18.3.200
    netmask 255.255.192.0
    gateway 172.18.0.254
    dns-search openstack.sj.ifsc.edu.br
    dns-nameservers 127.0.0.1

# Management
auto vlan450
iface vlan450 inet static
    vlan-raw-device em1
    address 10.45.0.200
    netmask 255.255.255.0

# Storage
auto vlan451
iface vlan451 inet static
    vlan-raw-device em1
    address 10.45.1.200
    netmask 255.255.255.0
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

# Remote access
auto em1
iface em1 inet static
    address 172.18.3.201
    netmask 255.255.192.0
    gateway 172.18.0.254
    dns-search openstack.sj.ifsc.edu.br
    dns-nameservers 10.45.0.200

# Management
auto vlan450
iface vlan450 inet static
    vlan-raw-device em1
    address 10.45.0.201
    netmask 255.255.255.0

# Storage
auto vlan451
iface vlan451 inet static
    vlan-raw-device em1
    address 10.45.1.201
    netmask 255.255.255.0

# Tunnel interface
auto vlan452
iface vlan452 inet static
    vlan-raw-device em1
    address 10.45.2.201
    netmask 255.255.255.0

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

# Remote access
auto em1
iface em1 inet static
    address 172.18.3.202
    netmask 255.255.192.0
    gateway 172.18.0.254
    dns-search openstack.sj.ifsc.edu.br
    dns-nameservers 10.45.0.200

# Management
auto vlan450
iface vlan450 inet static
    vlan-raw-device em1
    address 10.45.0.202
    netmask 255.255.255.0

# Storage
auto vlan451
iface vlan451 inet static
    vlan-raw-device em1
    address 10.45.1.202
    netmask 255.255.255.0

# Tunnel interface
auto vlan452
iface vlan452 inet static
    vlan-raw-device em1
    address 10.45.2.202
    netmask 255.255.255.0

# VMs
auto p5p1
iface p5p1 inet manual
```

And, to activate (repeated in all hosts):
```
ifdown em1
ifup em1
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
and agents in `openstack1` and `openstack2`:
```
aptitude install puppet
```

According to https://github.com/puppetlabs/puppet/commit/fc78774, there is a issue running `puppet resource service`. Fixed with:
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
- Put, in `openstack1` and `openstack2`, to wait for the master:
```
puppet agent --waitforcert 60
puppet agent --test
```
- In the master (`openstack0`):
```
puppet cert sign openstack1.sj.ifsc.edu.br
puppet cert sign openstack2.sj.ifsc.edu.br
```
- And, finally, in `openstack0`, `openstack1` and `openstack2`:
```
puppet agent --enable
puppet agent --test
```

## Puppet and git.
Ok, now mast and agents can communicate. Now, it's time to combine Puppet and git (this project):
- In master:
```
cd /etc
git clone https://github.com/boidacarapreta/openstack-ifsc.git
mv puppet/* openstack-ifsc/
ln -s openstack-ifsc/puppet puppet
```
Because there are two editors, @turnes and me (@boidacarapreta), it was necessary to change file modes:
```
chgrp -R git /etc/openstack-ifsc/
chmod -R g+w /etc/openstack-ifsc/
```

## Internal services
NTP, SNMP and even SSH (reconfigured) was installed and configured using puppet. Check the code :-)
