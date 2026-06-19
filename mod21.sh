


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
