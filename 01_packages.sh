#!/bin/bash

set -e  # Остановка при ошибке

# Подключаем переменные (если есть)
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🕒 Установка временной зоны..."
timedatectl set-timezone Asia/Tashkent

echo "🧹 Удаление Apache и MySQL, если установлены..."
apt remove --purge -y apache2 mysql-server || true
apt autoremove -y

echo "📦 Обновление системы..."
apt-mark hold python3    # 🔒 Зафиксировать Python 3.10
apt update && apt upgrade -y

echo "🔧 Установка вспомогательных утилит..."
apt install -y software-properties-common curl gnupg2 lsb-release ca-certificates

echo "🐘 Добавление репозитория PostgreSQL 17..."
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg
echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

echo "🧠 Добавление PPA Redis 7..."
export DEBIAN_FRONTEND=noninteractive
add-apt-repository -y ppa:redislabs/redis


apt update

echo "📦 Установка основных пакетов..."
apt install -y \
  postgresql-17 postgresql-client-17 libpq-dev \
  redis \
  nginx git vim \
  python3-pip python3-venv \
  rclone restic \
  rabbitmq-server \
  python3-certbot-nginx

echo "🔍 Проверка версий:"
echo -n "PostgreSQL: "; psql --version
echo -n "Redis: "; redis-server --version
echo -n "Python: "; python3 --version

echo "✅ Установка завершена!"
