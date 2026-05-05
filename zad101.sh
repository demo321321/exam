#!/bin/bash

# Установка dnsmasq
apt-get update
apt-get install dnsmasq -y

# Проверяем и назначаем IP-адрес 192.168.1.2 на интерфейсе
if ! ip addr show | grep -q "192.168.1.2"; then
    # Находим интерфейс (не loopback)
    IFACE=$(ip link show | grep -v lo | grep -v docker | grep -v veth | grep "^[0-9]:" | head -1 | awk -F': ' '{print $2}')
    if [ -n "$IFACE" ]; then
        ip addr add 192.168.1.2/24 dev $IFACE | true
        ip link set $IFACE up
        echo "Назначен IP 192.168.1.2 на интерфейс $IFACE"
    fi
fi

# Добавление конфигурации в конец файла /etc/dnsmasq.conf
# Сначала удаляем старые добавленные блоки, если есть
sed -i '/# Добавленная конфигурация dnsmasq/,/^$/d' /etc/dnsmasq.conf

cat >> /etc/dnsmasq.conf << 'EOF'

# Добавленная конфигурация dnsmasq
interface=*
bind-interfaces
server=8.8.8.8
domain=au-team.irpo
listen-address=127.0.0.1
listen-address=192.168.1.2
no-resolv
no-hosts

address=/hg-rtr.au-team.irpo/192.168.1.1
ptr-record=1.1.168.192.in-addr.arpa,hg-rtr.au-team.irpo
address=/br-rtr.au-team.irpo/192.168.3.1
address=/hg-srv.au-team.irpo/192.168.1.2
ptr-record=2.1.168.192.in-addr.arpa,hg-srv.au-team.irpo
address=/hg-cli.au-team.irpo/192.168.2.2
ptr-record=2.2.168.192.in-addr.arpa,hg-cli.au-team.irpo
address=/br-srv.au-team.irpo/192.168.3.2
address=/docker.au-team.irpo/172.16.1.1
address=/web.au-team.irpo/172.16.2.1
EOF

# Останавливаем службу если висит в failed
systemctl stop dnsmasq 2>/dev/null

# Перезапуск dnsmasq
systemctl restart dnsmasq

# Включение в автозагрузку и запуск
systemctl enable dnsmasq --now
