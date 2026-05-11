#!/bin/bash

# Обновление и установка chrony
apt-get update && apt-get install -y chrony

# Комментирование строки pool
sed -i 's/^pool 2.debian.pool.ntp.org iburst/#pool 2.debian.pool.ntp.org iburst/' /etc/chrony.conf

# Комментирование строки rtcsync
sed -i 's/^rtcsync/#rtcsync/' /etc/chrony.conf

# Добавление сервера в конец файла
echo "server 172.16.1.1 iburst" >> /etc/chrony.conf

# Перезапуск службы
systemctl restart chronyd

# Включение в автозагрузку
systemctl enable chronyd

#скрин
systemctl status chronyd
