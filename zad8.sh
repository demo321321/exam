#!/bin/bash

iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -p icmp --icmp-type echo-request -j ACCEPT

iptables-save > /etc/rules.v4

echo "Готово!"
