#!/bin/bash

apt-get update && apt-get install openssh

systemctl enable –now sshd
