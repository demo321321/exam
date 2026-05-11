#!/bin/bash

# Обновление пакетов
apt-get update

# Установка Samba DC
apt-get install -y task-samba-dc

# Удаление стандартного конфига
rm -rf /etc/samba/smb.conf

echo "samba-tool domain provision | mod11.sh"
