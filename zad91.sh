cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.bkp

# Комментирование строк option domain-name и option domain-name-servers
sed -i 's/^option domain-name "/#option domain-name "/' /etc/dhcp/dhcpd.conf
sed -i 's/^option domain-name-servers /#option domain-name-servers /' /etc/dhcp/dhcpd.conf

# Раскомментирование строки authoritative
sed -i 's/^#authoritative;/authoritative;/' /etc/dhcp/dhcpd.conf

# Добавление конфигурации подсети в конец файла
cat >> /etc/dhcp/dhcpd.conf << 'EOF'

subnet 192.168.2.0 netmask 255.255.255.240 {
    range 192.168.2.2 192.168.2.10;
    option domain-name-servers 192.168.1.2;
    option domain-search "au-team.irpo";
    option routers 192.168.2.1;
}
EOF

sleep 5
# Перезапуск DHCP-сервера
systemctl restart isc-dhcp-server

# Добавление в автозагрузку
systemctl enable isc-dhcp-server

echo "скрин /etc/dhcp/dhcpd.conf"
