# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'
Vagrant.require_version ">= 2.0.0"

CONFIG = File.join(File.dirname(__FILE__), "vagrant/config.rb")
COREOS_URL_TEMPLATE = "https://storage.googleapis.com/%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json"

DISK_UUID = Time.now.utc.to_i


SUPPORTED_OS = {
  "coreos-stable" => {box: "coreos-stable",      bootstrap_os: "coreos", user: "core", box_url: COREOS_URL_TEMPLATE % ["stable"]},
  "coreos-alpha"  => {box: "coreos-alpha",       bootstrap_os: "coreos", user: "core", box_url: COREOS_URL_TEMPLATE % ["alpha"]},
  "coreos-beta"   => {box: "coreos-beta",        bootstrap_os: "coreos", user: "core", box_url: COREOS_URL_TEMPLATE % ["beta"]},
  "ubuntu"        => {box: "bento/ubuntu-16.04", bootstrap_os: "ubuntu", user: "vagrant"},
  "centos"        => {box: "centos/7",           bootstrap_os: "centos", user: "vagrant"},
  "opensuse"      => {box: "opensuse/openSUSE-42.3-x86_64", bootstrap_os: "opensuse", use: "vagrant"},
  "opensuse-tumbleweed" => {box: "opensuse/openSUSE-Tumbleweed-x86_64", bootstrap_os: "opensuse", use: "vagrant"},
}

$num_instances = 3
$instance_name_prefix = "Jenkins"
$vm_gui = false
$vm_memory = 2048
$vm_cpus = 2
$shared_folders = {}
$forwarded_ports = {}
$subnet = "192.168.10"
$os = "centos"
$node_instances_with_disks_size = "20G"
$node_instances_with_disks_number = 3

if File.exist?(CONFIG)
  require CONFIG
end

$local_release_dir = "/vagrant/temp"

$box = SUPPORTED_OS[$os][:box]

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'



Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.box = $box
  if SUPPORTED_OS[$os].has_key? :box_url
    config.vm.box_url = SUPPORTED_OS[$os][:box_url]
  end
  config.ssh.username = SUPPORTED_OS[$os][:user]
  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  (1..$num_instances).each do |i|
     config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|
       config.vm.hostname = vm_name
       config.vm.provider :libvirt do |lv|
         lv.memory = $vm_memory
       end

       config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__args: ['--verbose', '--archive', '--delete', '-z']

       $shared_folders.each do |src, dst|
         config.vm.synced_folder src, dst, type: "rsync", rsync__args: ['--verbose', '--archive', '--delete', '-z']
       end

       config.vm.provider :virtualbox do |vb|
         vb.gui = $vm_gui
         vb.memory = $vm_memory
         vb.cpus = $vm_cpus
       end

       if $kube_node_instances_with_disks
         # Libvirt
         driverletters = ('a'..'z').to_a
         config.vm.provider :libvirt do |lv|
           # always make /dev/sd{a/b/c} so that CI can ensure that
           # virtualbox and libvirt will have the same devices to use for OSDs
           (1..$kube_node_instances_with_disks_number).each do |d|
             lv.storage :file, :device => "hd#{driverletters[d]}", :path => "disk-#{i}-#{d}-#{DISK_UUID}.disk", :size => $kube_node_instances_with_disks_size, :bus => "ide"
           end
         end
       end
       
      ip = "#{$subnet}.#{i+100}"
      config.vm.network :private_network, ip: ip
      # Disable swap for each vm
      config.vm.provision "shell", inline: "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config"
      config.vm.provision "shell", inline: "sudo systemctl restart sshd"
    end
  end
end
