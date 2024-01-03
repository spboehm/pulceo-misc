# Deploying a K3s cluster openSUSE MicroOS

## Requirements

* KVM with libvirt
* Vagrant

## How to proceed

* Create an ISO filesystem with the necessary files for Combustion and Ignition: `./create-combustion-iso.sh`. The created ISO filesystem will be mounted as CD-ROM into the virtual machine enable the initial configuration via Combustion.
* Spin up the testing environment: `vagrant up`

## TODOs

-[ ] Add UEFI configuration with Secure Boot
-[ ] Add TPM configuration
