
#!/bin/bash

# Restart services
systemctl restart gunicorn
systemctl restart redis-server
systemctl restart nginx
systemctl restart telegrambot

# Add cron jobs
(crontab -l 2>/dev/null; echo "45 */12 * * * certbot renew --quiet --allow-subset-of-names") | crontab -
(crontab -l 2>/dev/null; echo "20 9 * * * python3 /opt/findelta/main/manage.py get_cb_currency") | crontab -