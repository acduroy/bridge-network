#!/bin/bash

# Display network interfaces status
clear
# Execute at home directory
cd 
ip link

# Wait for user input # 
echo -n "Enter external network interface [ex. ens3]: "; read EXT
echo -n "Enter internal network interface [ex. ens8]: "; read INT 

echo "Check if ip tables rule.v4 exist"
sudo updatedb
IPT=$(locate -c -n 10 -i "rules.v4" /etc/iptables)
if [[ IPT -eq 0 ]]
then 
   printf " Output of IPT= $IPT\n"  
   echo "Downloading persistent iptable rules.v4 ..."
   install packages
   sudo apt-get install -y iptables-persistent
else
   echo "iptable rules.v4 exist, no need to download !!!"
fi

echo 'Setting up iptables rules for NAT' 
sudo iptables -t nat -A POSTROUTING -o $EXT -j MASQUERADE  
sudo iptables -A FORWARD -i $EXT -o $INT -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i $INT -o $EXT -j ACCEPT

# Locate IP forwarding at /etc/sysctl.conf
STR=$(grep -r "net.ipv4.ip_forward=1" /etc/sysctl.conf)
if [[ $STR != "" ]] 
then
   echo "enabling ip forwarding"
   sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
else
   echo "adding ip forwarding"	   
   echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf  
fi
sudo sysctl -p
sudo iptables-save | sudo tee /etc/iptables/rules.v4
printf "NAT enablement completed successfully !!!\n"
