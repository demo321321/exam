#!/bin/bash

# Добавление правил DNAT для проброса портов
iptables -t nat -A PREROUTING -d 172.16.1.2 -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.2:80
iptables -t nat -A PREROUTING -d 172.16.1.2 -p tcp --dport 2026 -j DNAT --to-destination 192.168.1.2:2026

# Сохранение конфигурации
iptables-save > /etc/rules.v4
