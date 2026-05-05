#!/bin/bash

# Установка DHCP-сервера
apt-get update && apt-get install -y isc-dhcp-server

# Настройка интерфейса
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth1.200"/' /etc/default/isc-dhcp-server

# Резервная копия
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp

# Новый конфиг
cat > /etc/dhcp/dhcpd.conf << 'EOF'
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# Option definitions common to all supported nodes.
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

ddns-update-style none;

authoritative;

# A slightly different configuration for an internal subnet.
subnet 192.168.2.0 netmask 255.255.255.240 {
    range 192.168.2.2 192.168.2.10;
    option domain-name-servers 192.168.1.2;
    option domain-search "au-team.irpo";
    option routers 192.168.2.1;
}
EOF

# Запуск и автозагрузка
systemctl restart isc-dhcp-server
systemctl enable isc-dhcp-server

echo "✅ DHCP-сервер настроен на HQ-RTR"
