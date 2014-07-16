#!/bin/bash

# Limpeza das regras antigas
iptables -t filter -F
#
# Política padrão: bloqueio
iptables -t filter -P INPUT   DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT  ACCEPT
#
# Manter os estados e loopback liberado
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i lo -j ACCEPT
#
# De externo para roteador: apenas ping (echo), SSH e HTTPS
iptables -t filter -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p tcp --dport 443 -j ACCEPT
iptables -t filter -A INPUT -i eth0 -p icmp --icmp-type echo-request -j ACCEPT
#
# De externo para virtualizadores: apenas ping (echo), DNS e SSH
iptables -t filter -A FORWARD -o eth1 -p udp --dport 53 -j ACCEPT
iptables -t filter -A FORWARD -o eth1 -p tcp --dport 22 -j ACCEPT
iptables -t filter -A FORWARD -o eth1 -p icmp --icmp-type echo-request -j ACCEPT
#
# De externo para VMs: tudo
iptables -t filter -A FORWARD -o eth2 -j ACCEPT
#
# De virtualizadores e VMs para externo: tudo
iptables -t filter -A FORWARD -o eth0 -j ACCEPT
#
# De virtualizadores para roteador: SNMP
iptables -t filter -A INPUT -i eth1 -p udp --dport 161 -j ACCEPT

