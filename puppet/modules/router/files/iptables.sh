#!/bin/bash

EXT="eth0"
HVS="eth1"
VMS="eth2"
VMS_NET="200.135.233.0/25"
VPN_NET="200.135.233.184/29"

# Cleaning rules.
iptables -t nat -F
iptables -t filter -F
#
# Default policies.
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t filter -P INPUT   DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT  ACCEPT
#
# Default rules, including VPN traffic.
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A INPUT -s 200.135.233.184/29 -j ACCEPT
#
# From: external;
# To: router;
# Services: SSH (22/TCP), VPN (500/UDP, 4500/UDP, MASQUERADING), Web (80/TCP, 443/TCP), ICMP ping.
iptables -t filter -A INPUT -i ${EXT} -p tcp --dport 22 -j ACCEPT
iptables -t filter -A INPUT -i ${EXT} -p udp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i ${EXT} -p udp --dport 4500 -j ACCEPT
iptables -t nat -A POSTROUTING -o ${EXT} -s ${VPN_NET} -j MASQUERADE
iptables -t filter -A INPUT -i ${EXT} -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -i ${EXT} -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -i ${EXT} -p icmp --icmp-type echo-request -j ACCEPT
#
# From: external;
# To: hypervisors;
# Services: DNS (53/UDP), ICMP ping.
iptables -t filter -A FORWARD -o ${HVS} -d 200.135.233.201/32 -p udp --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -o ${HVS} -d 200.135.233.202/32 -p udp --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -o ${HVS} -p icmp --icmp-type echo-request -j ACCEPT
#
# From: external;
# To: VMs;
# Services: any.
iptables -t filter -A FORWARD -o ${VMS} -j ACCEPT
#
# From: hypervisors + VMs;
# To: external;
# Services: any.
iptables -t filter -A FORWARD -o ${EXT} -j ACCEPT
#
# From: hypervisors;
# To: router;
# Services: SNMP (161/UDP), Zabbix (10050/TCP).
iptables -t filter -A INPUT -i ${HVS} -p udp --dport 161 -j ACCEPT
iptables -t filter -A INPUT -i ${HVS} -p tcp --dport 10050 -j ACCEPT
#
# From: VMs;
# To: hypervisors;
# Services: RabbitMQ (5672/TCP), Swift (80/TCP).
iptables -t filter -A FORWARD -i ${VMS} -s ${VMS_NET} -d 200.135.233.200/32 -p tcp --dport 5672 -j ACCEPT
iptables -t filter -A FORWARD -i ${VMS} -s ${VMS_NET} -d 200.135.233.203/32 -p tcp --dport 80 -j ACCEPT
