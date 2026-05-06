#!/bin/bash

# Копирование krb5.conf (без запроса подтверждения)
\cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf 2>/dev/null

# Включение Samba
systemctl enable samba --now

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

echo "Готово! Samba DC настроен на BR-SRV"
