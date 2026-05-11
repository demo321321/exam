#!/bin/bash

# Настройка SSH
echo "Port 2026" >> /etc/openssh/sshd_config
echo "AllowUsers sshuser" >> /etc/openssh/sshd_config
echo "PermitRootLogin no" >> /etc/openssh/sshd_config
echo "MaxAuthTries 2" >> /etc/openssh/sshd_config
echo "Banner /root/banner" >> /etc/openssh/sshd_config

# Создание баннера
echo "Authorized access only" >> /root/banner
echo "" >> /root/banner

(crontab -l 2>/dev/null; echo "@reboot /bin/systemctl restart network") | crontab -

# Перезапуск и добавление в автозагрузку
systemctl restart sshd
systemctl enable sshd
