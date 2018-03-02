nstall the software #
aptitude install bridge-utils

# Create the bridge network #
brctl addbr br0

# Add the interfaces to be bridged #
ip addr show  
# ex. eth0 and eth1 #
brctl addif br0 eth0 eth1

#  edit /etc/network/interfaces to look like below #
# iface eth0 inet manual 
# iface eth1 inet manual 
# iface br0 inet dhcp 
# bridge_ports eth0 eth1

