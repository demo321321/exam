#!/bin/bash

# Добавление правил DNAT для проброса портов
iptables -t nat -A PREROUTING -d 172.16.2.2 -p tcp --dport 8080 -j DNAT --to-destination 192.168.3.2:8080
iptables -t nat -A PREROUTING -d 172.16.2.2 -p tcp --dport 2026 -j DNAT --to-destination 192.168.3.2:2026

# Сохранение конфигурации
iptables-save > /etc/iptables.rules

echo "hq mod8b.sh"
