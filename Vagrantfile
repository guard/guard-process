# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.box = "guard"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :hostonly, "192.168.33.21"
  config.vm.share_folder "v-root", "/vagrant", ".", :nfs => !(ENV["OS"] =~ /windows/i)
  config.vm.provision :shell, :path => "vagrant-provision"
end
