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


samba-tool user create hquser1 P@ssw0rd
samba-tool user create hquser2 P@ssw0rd
samba-tool user create hquser3 P@ssw0rd
samba-tool user create hquser4 P@ssw0rd
samba-tool user create hquser5 P@ssw0rd

samba-tool group add hq

samba-tool group addmembers hq hquser1,hquser2,hquser3,hquser4,hquser5

