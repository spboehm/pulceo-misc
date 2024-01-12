#!/bin/bash
source server.env
### --- START HAPROXY CONFIGURATION --- ###
zypper --non-interactive install haproxy
    
    cat >/etc/haproxy/haproxy.cfg <<-EOF
    defaults
        timeout connect 10s
        timeout client 30s
        timeout server 30s

    frontend k3s-frontend
        bind *:6443
        mode tcp
        option tcplog
        default_backend k3s-backend

    backend k3s-backend
        mode tcp
        option tcp-check
        balance roundrobin
        default-server inter 10s downinter 5s
        server server-1 192.168.125.10:80 check
EOF

## set permissive mode for haproxy
semanage permissive -a haproxy_t
systemctl enable haproxy
### --- END HAPROXY CONFIGURATION --- ###
