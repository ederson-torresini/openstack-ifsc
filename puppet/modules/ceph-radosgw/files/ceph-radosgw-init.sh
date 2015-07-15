#!/bin/bash
#
# Based on https://ceph.com/docs/master/radosgw/keystone/

export OS_SERVICE_TOKEN=keystone
export OS_SERVICE_ENDPOINT=http://keystone.openstack.sj.ifsc.edu.br:35357/v2.0

keystone user-create --name swift --pass swift --email swift@openstack.sj.ifsc.edu.br
keystone user-role-add --user swift --tenant service --role admin

keystone service-create --name=swift --type=object-store --description="OpenStack Object Storage"
keystone endpoint-create --region ifsc-sj --service-id=$(keystone service-list | awk '/ object-store / {print $2}')  --publicurl=http://swift.openstack.sj.ifsc.edu.br/swift/v1  --internalurl=http://swift.openstack.sj.ifsc.edu.br/swift/v1  --adminurl=http://swift.openstack.sj.ifsc.edu.br/swift/v1

