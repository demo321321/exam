#!/bin/bash

mkdir -p /raid
# Создание RAID0 из дисков sdb и sdc
echo "mdadm --create /dev/md0 --level=[0] --raid-devices=[2] /dev/sdb /dev/sdc []"

# Сохранение конфигурации RAID
echo "mdadm --detail --scan > /etc/mdadm.conf"

# Создание раздела на RAID-массиве через fdisk (автоматически)
echo "echo -e ''n\np\n1\n\n\nw'' | fdisk /dev/md[0]"

# Форматирование раздела в ext4
echo "mkfs.ext4 /dev/md[0]p1"

# Монтирование вручную
echo "mount /dev/md[0]p1 /raid"

echo "mod21.sh"

echo "/etc/systemd/system/raid.m"


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
