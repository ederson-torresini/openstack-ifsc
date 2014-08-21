#!/bin/bash

# Limpeza das regras antigas
iptables -t nat -F
iptables -t filter -F
#
# Política padrão
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT ACCEPT
iptables -t filter -P INPUT   DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT  ACCEPT
#
# Manter os estados, liberar loopback (lo) e VPN
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A INPUT -s 200.135.233.183/29 -j ACCEPT
#
# De externo para roteador: SSH (22/TCP), VPN (500/UDP, 4500/UDP, MASQUERADING), Web (80/TCP, 443/TCP), ping.
iptables -t filter -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p udp --dport 500 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p udp --dport 4500 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -s 200.135.233.184/29 -j MASQUERADE
iptables -t filter -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p icmp --icmp-type echo-request -j ACCEPT
#
# De externo para virtualizadores: DNS (53/UDP), ping.
iptables -t filter -A FORWARD -o eth1 -p udp --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -o eth1 -p icmp --icmp-type echo-request -j ACCEPT
#
# De externo para VMs.
iptables -t filter -A FORWARD -o eth2 -j ACCEPT
#
# De virtualizadores e VMs para externo.
iptables -t filter -A FORWARD -o eth0 -j ACCEPT
#
# De virtualizadores para roteador: SNMP.
iptables -t filter -A INPUT -i eth1 -p udp --dport 161 -j ACCEPT

