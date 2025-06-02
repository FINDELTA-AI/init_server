#!/bin/bash

set -e

# Подключаем переменные
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🌐 Настройка Nginx..."

# Создание конфигурации
cat > /etc/nginx/sites-available/$PROJECT_NAME <<EOF
server {
    listen 80;
    server_name $PROJECT_NAME;

    location = /favicon.ico { access_log off; log_not_found off; }

    location /static/ {
        root $PROJECT_PATH_DJANGO;
    }

    location /media/ {
        root $PROJECT_PATH_DJANGO;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
EOF

# Удаление стандартного default-сайта
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default

# Активация нашего проекта
ln -sf /etc/nginx/sites-available/$PROJECT_NAME /etc/nginx/sites-enabled/$PROJECT_NAME

# Проверка и перезапуск
echo "🧪 Проверка Nginx конфигурации..."
nginx -t

echo "🔁 Перезапуск Nginx..."
systemctl restart nginx

echo "✅ Nginx настроен и перезапущен."
