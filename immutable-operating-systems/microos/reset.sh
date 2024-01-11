#!/bin/bash
killall -e vncviewer-tigervnc
vagrant halt
vagrant destroy -f
ssh-keygen -R 192.168.125.10 -f ~/.ssh/known_hosts
./create-combustion-iso.sh
vagrant up
/usr/bin/vncviewer-tigervnc localhost &