#!/bin/bash

# Обновление пакетов
apt-get update

# Установка Samba DC
apt-get install -y task-samba-dc

# Удаление стандартного конфига
rm -rf /etc/samba/smb.conf

echo "samba-tool domain provision"

# Копирование krb5.conf
cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Отключение BIND
systemctl disable bind --now 2>/dev/null

# Включение Samba
systemctl enable samba --now

# Добавление настроек interfaces
sed -i '/\[global\]/a\
  interfaces = lo ens18\
  bind interfaces only = yes' /etc/samba/smb.conf

# Перезапуск
systemctl restart samba

echo "Готово!"
