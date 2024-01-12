#!/bin/bash
cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 32 | head -n 1 > k3s/k3s_token
cp k3s/k3s_token microos/combustion-ignition/combustion/k3s_token