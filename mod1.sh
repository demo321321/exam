#!/bin/bash

# Копирование krb5.conf (без запроса подтверждения)
\cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf 2>/dev/null

# Включение Samba
systemctl enable samba

# Проверка, есть ли уже строки interfaces в smb.conf
if ! grep -q "interfaces = lo ens18" /etc/samba/smb.conf; then
    # Добавление настроек после секции [global]
    sed -i '/\[global\]/a\
interfaces = lo ens18\
bind interfaces only = yes' /etc/samba/smb.conf
    echo "Настройки interfaces добавлены в smb.conf"
else
    echo "Настройки interfaces уже присутствуют"
fi

# Перезапуск Samba
systemctl restart samba

samba-tool domain info 127.0.0.1

samba-tool user create hquser1 P@ssw0rd
samba-tool user create hquser2 P@ssw0rd
samba-tool user create hquser3 P@ssw0rd
samba-tool user create hquser4 P@ssw0rd
samba-tool user create hquser5 P@ssw0rd

samba-tool user list

samba-tool group add hq
samba-tool group addmembers hq hquser1,hquser2,hquser3,hquser4,hquser5
