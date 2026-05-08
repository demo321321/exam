#!/bin/bash

# Установка dnsmasq
apt-get update
apt-get install dnsmasq -y

# Добавление конфигурации в конец файла /etc/dnsmasq.conf
cat >> /etc/dnsmasq.conf << 'EOF'

interface=*
server=8.8.8.8
domain=au-team.irpo
listen-address=192.168.1.2
no-resolv
no-hosts

address=/hq-rtr.au-team.irpo/192.168.1.1
ptr-record=1.1.168.192.in-addr.arpa,hq-rtr.au-team.irpo
address=/br-rtr.au-team.irpo/192.168.3.1
address=/hq-srv.au-team.irpo/192.168.1.2
ptr-record=2.1.168.192.in-addr.arpa,hq-srv.au-team.irpo
address=/hq-cli.au-team.irpo/192.168.2.2
ptr-record=2.2.168.192.in-addr.arpa,hq-cli.au-team.irpo
address=/br-srv.au-team.irpo/192.168.3.2
address=/docker.au-team.irpo/172.16.1.1
address=/web.au-team.irpo/172.16.2.1
EOF

# Перезапуск dnsmasq
systemctl restart dnsmasq

# Включение в автозагрузку и запуск
systemctl enable dnsmasq --now
