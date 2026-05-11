#!/bin/bash

# Отключение ahttpd
systemctl disable ahttpd --now 2>/dev/null

# Установка Docker и Docker Compose
apt-get update
apt-get install -y docker-engine docker-compose

# Добавление Docker в автозагрузку и запуск
systemctl enable docker --now

# Создание директории для монтирования
mkdir -p /mnt/add_cd

# Монтирование диска (если /dev/sr0 существует)
mount /dev/sr0 /mnt/add_cd 2>/dev/null

# Копирование директории docker
cp -r /mnt/add_cd/docker /root/

# Импорт Docker-образов
docker image load -i /root/docker/site_latest.tar

docker image load -i /root/docker/mariadb_latest.tar

# Проверка образов
docker images

# Создание директории testapp
mkdir -p testapp
cd testapp

echo "Готово! Docker настроен, образы импортированы"
