#!/bin/bash


# Wait for user input # 
echo -n "Enter external network interface [ex. ens3]: "; read EXT
echo -n "Enter internal network interface [ex. ens8]: "; read INT 

# Download persistent iptable
echo "Downloading persistent iptable rule4 ..."
install packages
sudo apt-get install -y iptables-persistent

# Setting up iptables rules for NAT 
sudo iptables -t nat -A POSTROUTING -o $EXT -j MASQUERADE  
sudo iptables -A FORWARD -i $EXT -o $INT -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i $INT -o $EXT -j ACCEPT  
#echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf  
#sudo sysctl -p
sudo iptables-save | sudo tee /etc/iptables/rules.v4

