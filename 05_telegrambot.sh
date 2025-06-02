#!/bin/bash

set -e

# Подключаем переменные
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🤖 Настройка Telegram-бота..."

# Создание systemd сервиса для Telegram-бота
cat > /etc/systemd/system/telegrambot.service <<EOF
[Unit]
Description=Telegram Bot Service
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$PROJECT_PATH_TELEGRAMBOT
ExecStart=/usr/bin/python3 runbot.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Перезагрузка systemd и запуск
systemctl daemon-reload
systemctl enable telegrambot.service
systemctl start telegrambot.service

echo "✅ Telegram-бот запущен как systemd-сервис."
