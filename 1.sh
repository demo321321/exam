#!/bin/bash

# Добавление задания в crontab
(crontab -l 2>/dev/null; echo "@reboot /bin/systemctl restart network") | crontab -

echo "Готово! Задание добавлено в cron"
