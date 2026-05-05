#!/bin/bash

# Установка DHCP-сервера
apt-get update && apt-get install -y isc-dhcp-server

# Настройка интерфейса в /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth1.200"/' /etc/default/isc-dhcp-server

# Создание резервной копии конфига
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp

# Комментирование строк option domain-name и option domain-name-servers
sed -i 's/^option domain-name "/#option domain-name "/' /etc/dhcp/dhcpd.conf
sed -i 's/^option domain-name-servers /#option domain-name-servers /' /etc/dhcp/dhcpd.conf

# Раскомментирование строки authoritative
sed -i 's/^#authoritative;/authoritative;/' /etc/dhcp/dhcpd.conf

# Замена блока конфигурации подсети (ищем по комментарию)
if grep -q "# A slightly different configuration for an internal subnet." /etc/dhcp/dhcpd.conf; then
    sed -i '/# A slightly different configuration for an internal subnet./,/^}/c\
# A slightly different configuration for an internal subnet.\
subnet 192.168.2.0 netmask 255.255.255.240 {\
    range 192.168.2.2 192.168.2.10;\
    option domain-name-servers 192.168.1.2;\
    option domain-search "au-team.irpo";\
    option routers 192.168.2.1;\
}' /etc/dhcp/dhcpd.conf
fi

# Перезапуск DHCP-сервера
systemctl restart isc-dhcp-server

# Добавление в автозагрузку
systemctl enable isc-dhcp-server

echo "Готово! DHCP-сервер настроен на HQ-RTR"
