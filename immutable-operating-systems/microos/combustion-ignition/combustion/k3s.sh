### --- START K3S INSTALLATION --- ###
## K3S
source server.env
cat k3s_token >> /root/k3s_token
INSTALL_K3S_UPSTREAM=true  ## Set to false if you want to use the openSUSE rpm, also add the package name to USER_REQUIRED_PACKAGES
if $INSTALL_K3S_UPSTREAM; then
    ## Download and install the latest k3s installer
    curl -L --output k3s_installer.sh https://get.k3s.io && install -m755 k3s_installer.sh /usr/bin/
    ## Create a systemd unit that installs k3s if not installed yet
    cat <<- EOF > /etc/systemd/system/install-rancher-k3s.service
    [Unit]
    Description=Run K3s installer
    Wants=network-online.target
    After=network.target network-online.target
    ConditionPathExists=/usr/bin/k3s_installer.sh
    ConditionPathExists=!/usr/local/bin/k3s
    [Service]
    Type=forking
    TimeoutStartSec=120
    Environment="INSTALL_K3S_EXEC=$INSTALL_K3S_EXEC"
    ExecStart=/usr/bin/k3s_installer.sh
    ExecStartPost=/usr/sbin/reboot
    RemainAfterExit=yes
    KillMode=process
    [Install]
    WantedBy=multi-user.target
EOF
fi

systemctl enable install-rancher-k3s.service
### --- END K3S INSTALLATION --- ###
