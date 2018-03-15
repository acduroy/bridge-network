#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o $1 -j MASQUERADE  
sudo iptables -A FORWARD -i $1 -o $2 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i $2 -o eth0 -j ACCEPT  
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf  
sudo sysctl -p

