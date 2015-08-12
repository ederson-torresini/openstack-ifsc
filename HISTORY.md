Icehouse
===
The first release.

v1.0
===
Environment tagged after a half-year with no critical bugs.

From Icehouse to Juno
===
Upgrade documented in commit 39bd39e85cc8cba1bc65e73fd33f89f20b6aff4a.

Some databases need to be upgraded:
```
su -s /bin/bash - keystone -c "/usr/bin/keystone-manage db_sync"
su -s /bin/bash - glance -c "/usr/bin/glance-manage db_sync"
su -s /bin/bash - cinder -c "/usr/bin/cinder-manage db sync"
su -s /bin/bash - nova -c "/usr/bin/nova-manage db sync"
su -s /bin/bash - heat -c "/usr/bin/heat-manage db_sync"
su -s /bin/bash - ceilometer -c "/usr/bin/ceilometer-dbsync"
su -s /bin/bash - neutron -c "/usr/bin/neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/lbaas_agent.ini --config-file /etc/neutron/vpn_agent.ini --config-file /etc/neutron/l3_agent.ini --config-file /etc/neutron/fwaas_driver.ini stamp icehouse"
su -s /bin/bash - neutron -c "/usr/bin/neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/lbaas_agent.ini --config-file /etc/neutron/vpn_agent.ini --config-file /etc/neutron/l3_agent.ini --config-file /etc/neutron/fwaas_driver.ini upgrade head"
```

v1.1
===
Environment tagged after a half-year with no critical bugs.

From Juno to Kilo
===
Commits 0a9de2d65bf6d491818847611fdddb8055f8cfd6 to ab141bdef99d008750dc76c120e8c3e599337062 (and counting).

Some databases need to be upgraded, as the former version upgrade:
```
su -s /bin/bash - keystone -c "/usr/bin/keystone-manage db_sync"
su -s /bin/bash - glance -c "/usr/bin/glance-manage db_sync"
su -s /bin/bash - cinder -c "/usr/bin/cinder-manage db sync"
su -s /bin/bash - nova -c "/usr/bin/nova-manage db sync"
su -s /bin/bash - heat -c "/usr/bin/heat-manage db_sync"
su -s /bin/bash - ceilometer -c "/usr/bin/ceilometer-dbsync"
```
In Neutron, I had a lot of errors. I forgot to stamp the database, I guess. So, I had to fix manually (Python is my friend: many, many files in `/usr/lib/python2.7/dist-packages/neutron/db/migration/alembic_migrations/versions`). After it, I could run the regular commands:
```
su -s /bin/bash - neutron -c "/usr/bin/neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/lbaas_agent.ini --config-file /etc/neutron/vpn_agent.ini --config-file /etc/neutron/l3_agent.ini --config-file /etc/neutron/fwaas_driver.ini stamp juno"
su -s /bin/bash - neutron -c "/usr/bin/neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/lbaas_agent.ini --config-file /etc/neutron/vpn_agent.ini --config-file /etc/neutron/l3_agent.ini --config-file /etc/neutron/fwaas_driver.ini upgrade head"
```

VPNaaS, a Neutron plugin, was introduced in bdfe6b847e2bd3f99ae2cad12a1ff0199861fa7c, but no one really used it. So, I deactivated it to a simpler Neutron configuration.
