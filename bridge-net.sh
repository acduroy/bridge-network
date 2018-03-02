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

# Add the interfaces to be bridged #
brctl addif $BNAME $PRI_INT $SEC_INT

# Setup network config file #
sudo cp /etc/network/interfaces /etc/network/interfaces.bak
cat << BRIDGE | sudo tee /etc/network/interfaces

source /etc/network/interfaces.d/*
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $PRI_INT
iface $PRI_INT inet manual

# The secondary network interface
auto $SEC_INT
iface $SEC_INT inet manual

#The bride network interface
iface $BNAME inet dhcp 
bridge_ports $PRI_INT $SEC_INT

BRIDGE

# Reset network interface #
sudo ip addr flush $PRI_INT
sudo ip addr flush $SEC_INT
sudo services networking restart



