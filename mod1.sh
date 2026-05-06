#!/bin/bash

apt-get update
apt-get install task-samba-dc -y

rm -rf /etc/samba/smb.conf

samba-tool domain provision
