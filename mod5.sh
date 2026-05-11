#!/bin/bash

# Установка Ansible и sshpass
apt-get update && apt-get install -y ansible sshpass

# Создание файла инвентаря /etc/ansible/hosts
cat > /etc/ansible/hosts << 'EOF'
HQ-SRV ansible_host=192.168.1.2 ansible_user=sshuser ansible_password=P@ssw0rd ansible_port=2026
HQ-CLI ansible_host=192.168.2.2 ansible_user=user ansible_password=P@ssw0rd
HQ-RTR ansible_host=192.168.1.1 ansible_user=net_admin ansible_password=P@ssw0rd
BR-RTR ansible_host=192.168.3.1 ansible_user=net_admin ansible_password=P@ssw0rd

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# Проверка


echo "inventory = /etc/ansible/hosts"
echo "host_key_checking = False

ansible all -m ping"
