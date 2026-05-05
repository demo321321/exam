#!/bin/bash
sudo bash -c "useradd sshuser -u 2026 -m -s /bin/bash; echo 'sshuser:P@ssw0rd' | chpasswd; usermod -aG wheel sshuser"
