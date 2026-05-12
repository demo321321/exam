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
  testapp:
    image: site:latest
    container_name: testapp
    restart: always
    depends_on:
      - db
    ports:
      - 8080:8000
    environment:

      DB_TYPE: postgres
      DB_HOST: db
      DB_NAME: testdb
      DB_PORT: 5432
      DB_USER: test
      DB_PASS: P@ssw0rd

  db:
    image: postgres:15-alpine
    container_name: db
    restart: always
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: test
      POSTGRES_PASSWORD: P@ssw0rd
    volumes:
      - /root/testapp/db_data:/var/lib/mysql

volumes:
  db_data:
EOF


# Добавление задачи в crontab для автозапуска после перезагрузки
(crontab -l 2>/dev/null; echo "@reboot cd /root/testapp && /usr/bin/docker compose up -d") | crontab -

echo "cli http://192.168.3.2:8080

поменять /testapp/docker-compose.yaml

docker compose up -d

docker ps"
