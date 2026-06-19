#!/bin/bash

# Установка DHCP-сервера
apt-get update
apt-get install isc-dhcp-server -y

# Настройка интерфейса в /etc/default/isc-dhcp-server
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth1.200"/' /etc/default/isc-dhcp-server


echo "zad91.sh"
