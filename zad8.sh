#!/bin/bash

iptables -A FORWARD -m conntrack -ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -m conntrack -ctstate INVALID -j DROP

iptables-save > /etc/rules.v4
