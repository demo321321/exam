#!/bin/bash

# Установка nginx
apt-get update && apt-get install -y nginx

# Создание конфигурационного файла
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80;
    server_name web.au-team.irpo;

    location / {
        proxy_pass http://172.16.1.2:[8080];
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80;
    server_name docker.au-team.irpo;

    location / {
        proxy_pass http://172.16.2.2:[8080];
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF


systemctl enable nginx

# Перезапуск nginx
echo "/etc/nginx/sites-available/default"
echo "systemctl restart nginx"


echo "Готово! nginx настроен как reverse proxy"
