
#!/bin/bash
# This script will enable nat on a virtual machine with three (3) nic interfaces
install packages
sudo apt-get install -y iptables-persistent

# Show nic interfaces
ip link show

# Ask to confirm input and output interfaces
echo -n "Hostname (e.g. gw0): "; read HNAME
echo -n "Internal network interface (e.g. enp0s3): "; read INT
echo -n "Internal network interface address (e.g. 10.0.0.1): "; read INT_ADDR
echo -n "External network interface (e.g. enp0s8): "; read EXT
echo -n "Host-only network interface (e.g. enp0s9): "; read HOSTONLY

# Change host name
sudo hostnamectl set-hostname $HNAME
sudo cp /etc/hosts /etc/hosts.backup
sudo sed -i -e "s/^127.0.1.1.*$/127.0.1.1\t$HNAME/" /etc/hosts

# Enable IP forwarding
sudo sed -i -e 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# To enable the changes made in sysctl.conf you will need to run the command
sudo sysctl -p /etc/sysctl.conf

# Backup previous NAT rules to a file and flush all rules
sudo iptables-save | sudo tee /etc/iptables/rules.v4.backup
sudo iptables -t nat -F
sudo iptables -F

# Iptables rules for NAT
sudo iptables -t nat -A POSTROUTING -o $EXT -j MASQUERADE
sudo iptables -A FORWARD -i $EXT -o $INT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i $INT -o $EXT -j ACCEPT
# Accept ssh access (not verified)
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# Permanently save the NAT rules to a file
sudo iptables-save | sudo tee /etc/iptables/rules.v4
# or alternatively:
# sudo invoke-rc.d iptables-persistent save



# Reference
# https://www.upcloud.com/support/configuring-iptables-on-ubuntu-14-04/

# Config network interfaces:
# Show all network interfaces
ifconfig | grep "Link"

# Config network interfaces:
sudo cp /etc/network/interfaces /etc/network/interfaces.backup

cat << CFG | sudo tee /etc/network/interfaces

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The internal network interface
auto $INT
iface $INT inet static
address $INT_ADDR
netmask 255.255.255.0
broadcast 10.0.0.255

# The external network interface
auto $EXT
iface $EXT inet dhcp

# The host-only network interface
#auto $HOSTONLY
#iface $HOSTONLY inet dhcp

CFG


# Reset network service
sudo ip addr flush $INT
sudo ip addr flush $EXT
sudo service networking restart

# Review network info
ifconfig

