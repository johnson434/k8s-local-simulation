# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  N = 3 # max number of worker nodes
  Ver = '1.29.7' # Kubernetes Version to install
  USER_NAME = 'vagrant'
  
  #=============#
  # Master Node #
  #=============#

  config.vm.define "m-k8s" do |cfg|
    cfg.vm.box = "generic/ubuntu2204"
    cfg.vm.provider "virtualbox" do |vb|
      vb.name = "m-k8s(github_SysNet4Admin)"
      vb.cpus = 2
      vb.memory = 3072
      vb.customize ["modifyvm", :id, "--groups", "/k8s-SgMST-18.9.9(github_SysNet4Admin)"]
    end
     cfg.vm.host_name = "m-k8s"
     cfg.vm.network "private_network", ip: "192.168.1.10"
     cfg.vm.network "forwarded_port", guest: 22, host: 60010, auto_correct: true, id: "ssh"
     cfg.vm.synced_folder ".", "/vagrant"
     
     cfg.vm.provision "shell", inline: "ls -al"

     cfg.vm.provision "shell", path: "init.sh", args: ["MASTER"]
  end

  #==============#
  # Worker Nodes #
  #==============#

  (1..N).each do |i|
    config.vm.define "w#{i}-k8s" do |cfg|
      cfg.vm.box = "generic/ubuntu2204"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "w#{i}-k8s(github_SysNet4Admin)"
        vb.cpus = 1
        vb.memory = 2560
        vb.customize ["modifyvm", :id, "--groups", "/k8s-SgMST-18.9.9(github_SysNet4Admin)"]
      end
      cfg.vm.host_name = "w#{i}-k8s"
      cfg.vm.network "private_network", ip: "192.168.1.10#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "6010#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder ".", "/vagrant"
      cfg.vm.provision "shell", path: "init.sh", args: ["WORKER"]
    end
  end
end
