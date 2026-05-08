

#!/bin/bash

# Создание RAID0 из дисков sdb и sdc
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb /dev/sdc

# Сохранение конфигурации RAID
mdadm --detail --scan > /etc/mdadm.conf

# Создание раздела на RAID-массиве через fdisk (автоматически)
echo -e "n\np\n1\n\n\nw" | fdisk /dev/md0

# Форматирование раздела в ext4
mkfs.ext4 /dev/md0p1

# Создание точки монтирования
mkdir -p /raid

# Монтирование вручную
mount /dev/md0p1 /raid

# Создание systemd-unit для автоматического монтирования
cat > /etc/systemd/system/raid.mount << 'EOF'
[Unit]
Description=Mount RAID0

[Mount]
What=/dev/md0p1
Where=/raid
Type=ext4
Options=defaults

[Install]
WantedBy=multi-user.target
EOF

# Включение и запуск юнита
systemctl enable raid.mount --now

# Перемонтирование всех файловых систем
mount -a

# Проверка
df -h | grep raid
lsblk | grep md0

echo "Готово! RAID0 создан и смонтирован в /raid"
