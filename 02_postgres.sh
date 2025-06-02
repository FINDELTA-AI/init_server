#!/bin/bash

set -e  # Остановка при ошибке

# Подключаем переменные
if [ -f "./vars.sh" ]; then
  source ./vars.sh
fi

echo "🐘 Настройка базы данных PostgreSQL..."

# Проверка: существует ли база
DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
if [ "$DB_EXISTS" == "1" ]; then
    echo "⚠️ База данных $DB_NAME уже существует, пропускаем создание."
else
    echo "📦 Создание базы данных: $DB_NAME"
    sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;"
fi

# Проверка: существует ли пользователь
USER_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'")
if [ "$USER_EXISTS" == "1" ]; then
    echo "⚠️ Пользователь $DB_USER уже существует, пропускаем создание."
else
    echo "👤 Создание пользователя: $DB_USER"
    sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
fi

echo "🔧 Настройка параметров роли..."
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET client_encoding TO 'utf8';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET default_transaction_isolation TO 'read committed';"
sudo -u postgres psql -c "ALTER ROLE $DB_USER SET timezone TO 'Asia/Tashkent';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"

echo "📂 Настройка схемы public..."
sudo -u postgres psql -d $DB_NAME -c "GRANT ALL ON SCHEMA public TO $DB_USER;"
sudo -u postgres psql -d $DB_NAME -c "ALTER SCHEMA public OWNER TO $DB_USER;"

echo "✅ PostgreSQL: база '$DB_NAME' и пользователь '$DB_USER' настроены."
