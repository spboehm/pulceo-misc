#!/bin/bash
TMP_K3S_PATH="/tmp/k3s"
mkdir -p $TMP_K3S_PATH
K3S_VERSION=v1.28.5+k3s1
wget -nc -O $TMP_K3S_PATH/k3s https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s
chmod +x $TMP_K3S_PATH/k3s

$TMP_K3S_PATH/k3s token generate > k3s/k3s_token
cp k3s/k3s_token microos/combustion-ignition/combustion/k3s_token