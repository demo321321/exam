#!/bin/bash

# Обновление и установка chrony
apt update
apt install chrony -y

# Комментирование строк pool и rtcSync
sed -i 's/^pool /#pool /' /etc/chrony/chrony.conf
sed -i 's/^rtcSync /#rtcSync /' /etc/chrony/chrony.conf

# Добавление настроек в конец файла
cat >> /etc/chrony/chrony.conf << 'EOF'

local stratum 5
allow 172.16.1.0/28
allow 172.16.2.0/28
allow 192.168.1.0/27
allow 192.168.2.0/28
allow 192.168.3.0/28
EOF

# Перезапуск chrony
systemctl restart chronyd

# Отключение синхронизации времени
timedatectl set-ntp 0

# скрин
timedatectl

echo "mod4b.sh"
