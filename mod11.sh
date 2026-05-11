#!/bin/bash

cp /var/lib/samba/private/krb5.conf /etc/krb5.conf

# Отключение BIND
systemctl disable bind --now 2>/dev/null

# Включение Samba
systemctl enable samba --now

# Добавление настроек interfaces
echo 'interfaces = lo ens18 |
bind interfaces only = yes |
/etc/samba/smb'

# Перезапуск
systemctl restart samba
