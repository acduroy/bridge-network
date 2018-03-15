#!/bin/bash

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o br1 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i br1 -o eth0 -j ACCEPT  
echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf  
sudo sysctl -p

