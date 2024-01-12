# Deploying a K3s cluster openSUSE MicroOS

## Requirements

* KVM with libvirt
* Vagrant
* [OPTIONAL] Add the normal user to `qemu` and `libvirt` group

## How to proceed

* Create an ISO filesystem with the necessary files for Combustion and Ignition: `./create-combustion-iso.sh`. The created ISO filesystem will be mounted as CD-ROM into the virtual machine enable the initial configuration via Combustion.
* Spin up the testing environment: `vagrant up`

## TODOs

- [ ] Add UEFI configuration with Secure Boot
- [ ] Add TPM configuration
- [ ] Revise SELINUX settings for haproxy_t in `immutable-operating-systems/microos/combustion-ignition/combustion/script`
- [ ] Refactor to one invocation of `zypper install [PKGs]` to reduce deployment time
- [ ] Provide pre-built image: [MicroOS Images](https://build.opensuse.org/package/show/openSUSE:Factory/openSUSE-MicroOS)
- [ ] Remove `wget`, `curl`, and `nano` before adding the production network
- [ ] Bump K3S version to v1.29
- [ ] Check variable export in `script`, introduce concise `env`-files
- [ ] Introduce further variables in folder `var` for all `env`-files