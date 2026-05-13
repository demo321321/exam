#!/bin/bash

# Обновление и установка chrony (с автоматическим подтверждением)
apt-get update && apt-get install -y chrony

# Комментирование строки pool
sed -i 's/^pool 2.debian.pool.ntp.org iburst/#pool 2.debian.pool.ntp.org iburst/' /etc/chrony/chrony.conf

# Добавление новых настроек в конец файла
cat >> /etc/chrony/chrony.conf << 'EOF'

# Добавленные настройки
server 0.ru.pool.ntp.org iburst prefer minstratum 4
local stratum 5
allow 0.0.0.0/0
EOF

# Перезапуск службы
systemctl restart chronyd

# Включение в автозагрузку
systemctl enable chronyd

echo "mod4b
mod4c"
