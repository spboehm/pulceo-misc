#!/bin/bash
exec > >(exec tee -a /dev/tty0) 2>&1
# Host pmn11
#     HostName 192.168.125.10
#     User root
#     IdentityFile ~/.ssh/ios-microos
#     Port 22