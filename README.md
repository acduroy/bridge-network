# bridge-network script creation 
# 
# 
# Procedure in installing KVM on Ubuntu desktop 16.04.3 
# Note: First, make sure Network Manager is disabled at Ubuntu 16.04.3 Desktop rebuild
#       To disable do the following -> $ sudo systemctl disable Network Manaager
# A. Check if CPU supports hardware virtualization
#   1.) $ sudo apt install cpu-checker -y
#   2.) $ sudo kvm-ok 
#   Output: shoud be "/dev/kvm exist and KVM accelaraton can be used"
# B. Installation of KVM for Ubuntu 10.04 and later
#   1.) $ sudo apt-get install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils -y
#   2.) Verify installation -> $ virsh list --all
#   3.) Check if sock file have permissions -> $ sudo ls -la /var/run/libvirt/libvirt-sock
#   4.) Check if '/dev/kvm' is in the right group -> $ ls -l /dev/kvm
#       Output should not be: "crw-rw----+ 1 root root 10, 232 Jul  8 22:04 /dev/kvm"
#   5.) Otherwise: Change the device's group to kvm/libvirtd instead: -> $ sudo chown root:libvirtd /dev/kvm
# C. Installation of virtual manager (GUI) -> $ sudo apt-get install virt-manager

# reference websiste -> https://help.ubuntu.com/community/KVM/Installation
#
# Teamviewer - to install:
# $sudo dpkg -i <path/to/deb.deb>
# $sudo apt-get install -f
# 
# Teamviewer - to remove:
# $sudo apt-get purge teamviewer
#
#
# Virtual Manager - to delete virtual network:
# $virsh net-list
# $virsh net-destroy default
# $virsh net-undefine default
# $sudo service libvirtd restart
# ifconfig
#
#
# Bridge Networking:
# 1) To delete dridge network 
# $sudo ip link set <bridge_name> down
# $sudo brctl delbr <bridge_name>
#
# 2) To create bridge network
# $sudo brctl addbr <bridge_name>
# $brctl show
# $sudo ifup <bridge_name>
#
# 3) To create bridge interface permanently (edit /etc/network/interfaces)
# * auto <bridge_name>
# * iface <bridge_name> inet dhcp
# * bridge_ports <interface_to_bridge; ex. enp1s0f2>
# * bridge_stp off
# * bridge_fd 0
# * bridge_maxwait 0
#
#
# Debugging network problem
# Open a syslog event log by executing the ff: command
# $ tail -f /var/log/syslog
