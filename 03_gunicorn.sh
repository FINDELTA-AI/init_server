#!/bin/bash

set -e

# Подключаем переменные
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🔧 Настройка Gunicorn..."

# Создание Gunicorn сокета
cat > /etc/systemd/system/gunicorn.socket <<EOF
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
EOF

# Создание Gunicorn сервиса
cat > /etc/systemd/system/gunicorn.service <<EOF
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$PROJECT_PATH_DJANGO
ExecStart=/usr/local/bin/gunicorn --access-logfile - --workers 4 --bind unix:/run/gunicorn.sock core.wsgi:application

[Install]
WantedBy=multi-user.target
EOF

echo "🔁 Перезапуск systemd для Gunicorn..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable gunicorn.socket
systemctl start gunicorn.socket
systemctl restart gunicorn.service

echo "✅ Gunicorn настроен и запущен."
