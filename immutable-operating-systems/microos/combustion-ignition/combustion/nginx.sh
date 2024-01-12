#!/bin/bash
source server.env
### --- EXAMPLE: START NGINX --- ###
zypper --non-interactive install nginx
systemctl enable nginx
### --- EXAMPLE: END NGINX --- ###
