#!/bin/bash

# Копирование krb5.conf (без запроса подтверждения)
\cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf 2>/dev/null

# Полная замена smb.conf
cat > /etc/samba/smb.conf << 'EOF'
# Global parameters
[global]
        dns forwarder = 192.168.1.2
        netbios name = BR-SRU
        realm = AU-TEAM.IRPO
        server role = active directory domain controller
        workgroup = AU-TEAM
        interfaces = lo ens18
        bind interfaces only = yes

[sysvol]
        path = /var/lib/samba/sysvol
        read only = No

[netlogon]
        path = /var/lib/samba/sysvol/au-team.irpo/scripts
        read only = No
EOF

# Включение и перезапуск Samba
systemctl enable samba
systemctl restart samba

echo "samba-tool user create hquser1 P@ssw0rd и samba-tool group add hq
samba-tool group addmembers hq hquser1,"
