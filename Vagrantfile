# -*- mode: ruby -*- # vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.hostname = 'railsmatc'
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
   config.vm.synced_folder "./workspace", "/home/vagrant/workspace"

   config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
   end

  config.vm.network :private_network, ip: "33.33.13.38"

   config.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update
     sudo apt-get install -y autoconf automake bison build-essential curl git-core libapr1 libaprutil1 libc6-dev libltdl-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libtool libxml2-dev libxslt-dev libxslt1-dev libyaml-dev ncurses-dev nodejs openssl sqlite3 zlib1g zlib1g-dev
     sudo apt-get install -y node
     sudo apt-get install -y npm
   SHELL
end
