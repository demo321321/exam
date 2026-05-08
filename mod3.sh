#!/bin/bash

# Обновление пакетов
apt-get update

# Установка NFS-сервера
apt-get install nfs-server -y

# Создание директории
mkdir -p /raid/nfs

# Выдача полных прав
chmod 777 /raid/nfs

# Добавление строки в конец файла /etc/exports (без замены)
echo "/raid/nfs 192.168.2.0/28(rw,no_subtree_check)" >> /etc/exports

# Применение конфигурации
exportfs -a

# Активация и добавление в автозагрузку
systemctl enable nfs-server --now

echo "hq-cli"
