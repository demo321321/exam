#!/bin/bash
useradd -m net_admin -u 2026
passwd net_admin
P@ssw0rd
P@ssw0rd
usermod -aG sudo net_admin
echo "Пользователь sshuser успешно создан"
