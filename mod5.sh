#!/bin/bash

# Установка Ansible и sshpass
apt-get update && apt-get install -y ansible sshpass

# Создание файла инвентаря /etc/ansible/hosts
cat > /etc/ansible/hosts << 'EOF'
[servers]
HQ-SRV ansible_host=192.168.1.2 ansible_user=sshuser ansible_password=P@ssw0rd ansible_port=2026
HQ-CLI ansible_host=192.168.2.2 ansible_user=user ansible_password=resu
HQ-RTR ansible_host=192.168.1.2 ansible_user=net_admin ansible_password=P@ssw0rd
BR-RTR ansible_host=192.168.3.1 ansible_user=net_admin ansible_password=P@ssw0rd

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# Настройка ansible.cfg
sed -i 's/#inventory      = /etc/ansible/hosts/inventory = /etc/ansible/hosts/' /etc/ansible/ansible.cfg 2>/dev/null
if ! grep -q "inventory = /etc/ansible/hosts" /etc/ansible/ansible.cfg; then
    echo -e "\n[defaults]\ninventory = /etc/ansible/hosts\nhost_key_checking = False" >> /etc/ansible/ansible.cfg
fi

# Отключение проверки ключей хоста
if ! grep -q "host_key_checking = False" /etc/ansible/ansible.cfg; then
    sed -i 's/#host_key_checking = False/host_key_checking = False/' /etc/ansible/ansible.cfg
fi

# Проверка
ansible all -m ping

echo "Готово! Ansible настроен"
