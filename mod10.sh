#!/bin/bash

# Установка nginx и apache2-utils
apt-get update && apt-get install -y nginx apache2-utils

# Создание пользователя WEB с паролем P@ssw0rd
echo "P@ssw0rd" | htpasswd -c /etc/nginx/.htpasswd WEB

# Создание конфигурационного файла с аутентификацией
cat > /etc/nginx/sites-available/default << 'EOF'
server {
    listen 80;
    server_name web.au-team.irpo;

    location / {
        proxy_pass http://172.16.1.2:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        auth_basic "Restricted area";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}

server {
    listen 80;
    server_name docker.au-team.irpo;

    location / {
        proxy_pass http://172.16.2.2:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Проверка конфигурации
nginx -t

# Перезапуск nginx
systemctl restart nginx

# Включение в автозагрузку
systemctl enable nginx

echo "Готово! nginx настроен с web-аутентификацией"
