#!/bin/bash

samba-tool user create hquser1 P@ssw0rd
samba-tool user create hquser2 P@ssw0rd
samba-tool user create hquser3 P@ssw0rd
samba-tool user create hquser4 P@ssw0rd
samba-tool user create hquser5 P@ssw0rd

samba-tool group add hq

samba-tool group addmembers hq hquser1,hquser2,hquser3,hquser4,hquser5

