#!/bin/bash

# Установка DHCP-сервера
apt-get update
apt-get install isc-dhcp-server -y

# Настройка интерфейса в /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth1.200"/' /etc/default/isc-dhcp-server

# Создание резервной копии конфига
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp

# Комментирование строк option domain-name и option domain-name-servers
sed -i 's/^option domain-name "/#option domain-name "/' /etc/dhcp/dhcpd.conf
sed -i 's/^option domain-name-servers /#option domain-name-servers /' /etc/dhcp/dhcpd.conf

# Раскомментирование строки authoritative
sed -i 's/^#authoritative;/authoritative;/' /etc/dhcp/dhcpd.conf

# Добавление конфигурации подсети в конец файла
cat >> /etc/dhcp/dhcpd.conf << 'EOF'

subnet 192.168.2.0 netmask 255.255.255.240 {
    range 192.168.2.2 192.168.2.10;
    option domain-name-servers 192.168.1.2;
    option domain-search "au-team.irpo";
    option routers 192.168.2.1;
}
EOF

# Перезапуск DHCP-сервера
systemctl restart isc-dhcp-server

# Добавление в автозагрузку
systemctl enable isc-dhcp-server
