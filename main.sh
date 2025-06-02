#!/bin/bash

set -e

source ./vars.sh

./01_packages.sh
./02_postgres.sh
./03_gunicorn.sh
./04_dramatiq.sh
./05_telegrambot.sh
./06_nginx.sh

echo "✅ Full setup complete!"
