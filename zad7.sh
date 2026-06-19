#!/bin/bash

# Добавление репозитория Debian Buster (с подавлением ошибок GPG)
echo "deb [trusted=yes] https://archive.debian.org/debian buster main" >> /etc/apt/sources.list

# Обновление и установка FRR
apt update
apt install frr -y

# Включение ospfd в демонах
sed -i 's/ospfd=no/ospfd=yes/' /etc/frr/daemons

# Запуск и добавление в автозагрузку
systemctl enable frr
systemctl restart frr

sleep 5
# Настройка OSPF через vtysh
vtysh << EOF
conf t
router ospf
network 10.0.0.0/30 area 0
network 192.168.1.0/27 area 0
network 192.168.2.0/28 area 0
network 192.168.99.0/29 area 0
exit
interface gre1
ip ospf authentication message-digest
ip ospf message-digest-key 1 md5 P@ssw0rd
exit
do wr mem
exit
EOF

echo "скрин do show ip ospf route
zad72"
