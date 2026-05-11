#!/bin/bash

# Отключение ahttpd
systemctl disable ahttpd --now

# Установка Docker и Docker Compose
apt-get update
apt-get install -y docker-engine docker-compose

# Добавление Docker в автозагрузку и запуск
systemctl enable docker --now

# Создание директории для монтирования
mkdir -p /mnt/add_cd

# Монтирование диска
mount /dev/sr0 /mnt/add_cd

# Копирование директории docker
cp -r /mnt/add_cd/docker /root/

# Импорт Docker-образов
docker image load -i /root/docker/site_latest.tar
docker image load -i /root/docker/mariadb_latest.tar

# Создание директории testapp
mkdir -p /root/testapp
cd /root/testapp

# Создание файла docker-compose.yaml
cat > docker-compose.yaml << 'EOF'
services:
1testapp:
2image: site:latest
2container_name: testapp
2restart: always
2depends_on:
3- db
2ports:
3- 8080:8080
2environment:

3DB_TYPE: postgres
3DB_HOST: db
3DB_NAME: testdb
3DB_PORT: 5432
3DB_USER: test
3DB_PASS: P@ssw0rd

1db:
2image: postgres:15-alpine
2container_name: db
2restart: always
2environment:
3POSTGRES_DB: testdb
3POSTGRES_USER: test
3POSTGRES_PASSWORD: P@ssw0rd
2volumes:
3- db_data:/var/lib/postgresql/data

volumes:
1db_data:
EOF


# Добавление задачи в crontab для автозапуска после перезагрузки
(crontab -l 2>/dev/null; echo "@reboot cd /root/testapp && /usr/bin/docker compose up -d") | crontab -

echo "cli http://192.168.3.2:8080

docker compose up -d

docker ps"
