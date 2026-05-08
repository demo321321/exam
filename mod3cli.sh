#!/bin/bash

# Установка NFS-клиента
apt-get update
apt-get install nfs-common -y

# Создание директории для монтирования
mkdir -p /mnt/nfs

# Создание systemd unit для монтирования NFS
mkdir -p /etc/systemd/system
cat > /etc/systemd/system/mnt-nfs.mount << 'EOF'
[Unit]
Description=Mount NFS

[Mount]
What=192.168.1.2:/raid/nfs
Where=/mnt/nfs
Type=nfs
Options=_netdev,auto

[Install]
WantedBy=multi-user.target
EOF

# Перезагрузка systemd и включение юнита
systemctl daemon-reload
systemctl enable mnt-nfs.mount
systemctl start mnt-nfs.mount

# Применение всех монтирований
mount -a

# Проверка монтирования
df -h | grep /mnt/nfs

# Создание тестового файла
touch /mnt/nfs/test 2>/dev/null

# Проверка
echo "скрин"
ls -lah /mnt/nfs/

