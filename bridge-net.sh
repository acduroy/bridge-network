#!/bin/bash

#install the software #
aptitude install bridge-utils

# show network interfaces #
ifconfig |grep -i Link
echo 

# Network info from User input here: #
echo -n "Enter primary network interface [ex. eno1]: "; read PRI_INT
echo -n "Enter secondary network interface [ex. eno2]: "; read SEC_INT
echo -n "Enter bridge name [ex. br0]: "; read BNAME

# temporary name
# brctl addbr $BNAME

# Setup network config file #
sudo cp /etc/network/interfaces /etc/network/interfaces.bak
cat << BRIDGE | sudo tee /etc/network/interfaces

source /etc/network/interfaces.d/*
# The loopback network interface



# Add the interfaces to be bridged #
ip addr show  
# ex. eth0 and eth1 #
brctl addif br0 eth0 eth1

#  edit /etc/network/interfaces to look like below #
# iface eth0 inet manual 
# iface eth1 inet manual 
# iface br0 inet dhcp 
# bridge_ports eth0 eth1

