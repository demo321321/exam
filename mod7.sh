#!/bin/bash

# Установка LAMP-сервера
apt-get update && apt-get install -y lamp-server

# Монтирование диска
mount /dev/sr0 /mnt/

# Копирование файлов веб-приложения
cp /mnt/web/index.php /var/www/html/
cp /mnt/web/logo.png /var/www/html/

# Включение и запуск mariadb
systemctl enable --now mariadb

# Настройка базы данных
mariadb -u root << EOF
CREATE DATABASE webdb;
CREATE USER 'web'@'localhost' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON webdb.* TO 'web'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
EOF

# Импорт dump.sql
mariadb -u web -pP@ssw0rd -D webdb < /mnt/web/dump.sql

# Редактирование index.php с правильными учётными данными
sed -i 's/username = ".*"/username = "web"/' /var/www/html/index.php
sed -i 's/password = ".*"/password = "P@ssw0rd"/' /var/www/html/index.php
sed -i 's/dbname = ".*"/dbname = "webdb"/' /var/www/html/index.php
sed -i 's/servername = ".*"/servername = "localhost"/' /var/www/html/index.php

echo "mcedit /etc/httpd2/conf/sites-available/default.conf

systemctl enable --now httpd2"

# Включение и запуск httpd2
