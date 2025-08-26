This script can be used to quickly install weewx v5 using pip
as well as optionally installing the Belchertown skin.

It provides a couple flags to optionally do other things:
 - install Belchertown skin
 - and/or run this as a vagrant provisioner script

If run as a Vagrant provisioner script, be sure to set
the Vagrantfile to run 'unprivileged' as the default
user vagrant.  A typical Vagrantfile would look like:

    # -*- mode: ruby -*-
    # vi: set ft=ruby :
    Vagrant.configure("2") do |config|
      config.vm.box = "debian-12.4-aarch64/20231220"
      config.vm.hostname = "deb12pip"
      config.vm.box_check_update = false
      config.vm.provision "shell", path: "provision.sh", privileged: false
      config.vm.provider "parallels" do |vb, override|
        override.vm.network "forwarded_port", guest: 80,   host: 9999
      end
    end


Quick install for just weewx+nginx would be:

   wget -qO - https://raw.githubusercontent.com/vinceskahan/weewx-pipinstall/main/install-v5pip.sh | bash
