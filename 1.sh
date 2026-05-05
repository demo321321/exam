#!/bin/bash
useradd sshuser -u 2026
passwd sshuser
P@ssw0rd
P@ssw0rd
usermod -aG wheel sshuser
echo "Пользователь sshuser успешно создан"
