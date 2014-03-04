# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

$install_chef = <<SCRIPT
if ! [ -d '/opt/chef' ];
then
  curl -L https://www.opscode.com/chef/install.sh | sudo bash
fi
SCRIPT

provisioner = {
  cookbooks: "cookbooks",
  roles: "roles",
  databags: "data_bags"
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "centos" do |centos|
    centos.vm.provision :shell, :inline => $install_chef
    centos.vm.box ="opscode_centos-6.5_chef-provisionerless"
    centos.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
    centos.vm.provider "virtualbox" do |v|
      v.memory = 256
    end
    if Vagrant.has_plugin?("vagrant-cachier")
      centos.cache.auto_detect = true
      # If you are using VirtualBox, you might want to enable NFS for shared folders
      # centos.cache.enable_nfs  = true
    end
    centos.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = provisioner[:cookbooks]
      chef.roles_path = provisioner[:roles]
      chef.data_bags_path = provisioner[:databags]
      chef.arguments = '-l debug'
      chef.run_list = [
        "recipe[chef-solo-search]",
        "recipe[zookeeperd::server]"
      ]
      chef.json = {
      }
    end
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.provision :shell, :inline => "sudo apt-get intsall curl -y"
    ubuntu.vm.provision :shell, :inline => $install_chef
    ubuntu.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"
    ubuntu.vm.box = "opscode_ubuntu-12.04_chef-provisionerless"
    ubuntu.vm.provider "virtualbox" do |v|
      v.memory = 256
    end
    if Vagrant.has_plugin?("vagrant-cachier")
      ubuntu.cache.auto_detect = true
      # If you are using VirtualBox, you might want to enable NFS for shared folders
      # ubuntu.cache.enable_nfs  = true
    end
    ubuntu.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = provisioner[:cookbooks]
      chef.roles_path = provisioner[:roles]
      chef.data_bags_path = provisioner[:databags]
      chef.arguments = '-l debug'
      chef.run_list = [
        "recipe[chef-solo-search]",
        "recipe[zookeeperd::server]"
      ]
      chef.json = {
      }
    end
  end

end
