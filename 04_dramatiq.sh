#!/bin/bash

set -e

# Подключаем переменные
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🔧 Настройка Dramatiq..."

# Создание systemd сервиса для Dramatiq
cat > /etc/systemd/system/dramatiq.service <<EOF
[Unit]
Description=Dramatiq Worker
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$PROJECT_PATH_DRAMATIQ
ExecStart=/usr/bin/python3 manage.py rundramatiq
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Перезагрузка systemd и запуск сервиса
systemctl daemon-reload
systemctl enable dramatiq.service
systemctl start dramatiq.service

echo "✅ Dramatiq запущен и работает как systemd-сервис."
