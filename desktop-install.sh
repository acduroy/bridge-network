sudo systemctl disable NetworkManager
sudo cp /etc/network/interfaces /etc/network/interfaces.backup

cat << CFG | sudo tee /etc/network/interfaces

#source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The internal network interface
auto eno1 #$INT
iface eno1 dhcp

#iface $INT inet static
#address $INT_ADDR
#netmask 255.255.255.0
#broadcast 10.0.0.255

# The external network interface
auto eno2 #$EXT
iface eno2 inet static   #$EXT inet dhcp
address 10.100.209.1
netmask 255.255.255.0
broadcast 10.100.209.255

# The host-only network interface
#auto $HOSTONLY
#iface $HOSTONLY inet dhcp

CFG

#Re-flush the network interface
sudo ip addr flush eno1 
sudo service networking restart
sudo ip addr flush eno2
sudo service networking restart

#install ssh
sudo apt-get install openssh-server -y

#testing the networks
ping 8.8.8.8
nslookup yahoo.com

#reboot the system
reboot
