#!/bin/bash

# Prerequisite: Ubuntu Server OS installed on MAAS server in this case 16.04 LTS release
# Below steps will install maas from packages
# Ref: https://docs.maas.io/2.3/en/installconfig-package-install

# At MAAS server do:
# Execute command at home directory
clear
cd $HOME
echo "Show full list of maas packages" 
sudo apt-cache search maas

echo "Adding a stable package repositories"
sudo apt-add-repository -yu ppa:maas/stable

echo "Initial setup of MAAS environment" 
sudo apt update 
sudo apt install maas -y

# Create admin user
#sudo maas createadmin  

# Alternative way to create MAAS user with script
# ex. username = "vmaas201", password = "Super123"
echo "*** Creating admin maas user ***"
echo -n "Enter username[ex. maas]: "; read PROFILE
echo -n "Enter email[ex. acduroy@yahoo.com] "; read EMAIL_ADDRESS

sudo maas createadmin --username=$PROFILE --emaail=$EMAIL_ADDRESS

printf "*** Import SSH keys can be done at MAAS web UI ***\n"
printf "*** Go to any web browser (ex. IE) and type in http://<your_maas_ip>:5240/MAAS ***\n"
printf "*** Login to maas user and fill in the details of your MAAS' settings ***" 
printf "*** For DNS forwarder value, use the DNS ip address provided by the nslookup command ***\n"
printf "*** See the nslookup output below ***\n"
nslookup yahoo.com 
printf "*** Once all initial settings are entered at the web UI, you can now setup your SSH public key ***\n"
read -n 1 -s -r -p "Press any key to generate public key ..."

#Generate SSH Key
cd ~
ssh-keygen

echo " Copy the public key authentication and paste it on SSH keys admin entry at web UI ***" 
cat ~/.ssh/id_rsa.pub

echo "*** Go to the Subnets tab  ***"
echo "*** Add Fabric to the MAAS in networks  ***"
echo "*** Add subnet to the Fabric  ***"
echo "*** At Subnet sub-page, fill in the CIDR = network ip xx.xx.xx.0/24 ***"
echo "*** Gateway and DNS = it should be the maas server internal ip address (ex.ens8)  ***"
echo "\n"
echo "*** Turn on DHCP ***"
echo "*** Select default VLAN assigned to the Fabric under column VLAN ***"
echo "*** Set the Rack controller that will manage DHCP (in this case the "MAAS") ***"
echo "*** From the "Take action" button, select "Provide DHCP" ***"
echo "\n"
#Enlist and commission servers
echo "*** At target node BIOS: ***"
echo "*** Set all servers to PXE boot (make sure the right NIC interface as the boot device) ***"
echo "*** Set IPMI to DHCP mode   ***"
echo "*** Boot each machine. Machines will be automatically enlisted in the Nodes tab ***"
echo "*** Select all machines and "Commission" them using the "Take action" button ***"
echo "*** Once machines are in "Ready" status, you can start deploying ***"
echo "\n"
echo "*** To add virtual node to these steps below: ***"
echo "*** MAAS with KVM  ***"
echo "*** ref: https://docs.maas.io/2.3/en/nodes-add ***"
echo "*** The procedure below is to add nodes via a Pod  ***"

echo "Installing lib virtual  to maas server"
sudo apt install libvirt-bin -y

echo "*** Now generating SSH Key for maas superuser **"
sudo chsh -s /bin/bash maas
sudo su - maas
ssh-keygen -f ~/.ssh/id_rsa -N ''

#Wait for user input
echo -n "Enter KVM Host user name[ex.acd]: "; read USER
echo -n "Enter Host Bridge (br xxx) Internal ip address[ex.10.100.201.2]: "; read KVM_HOST
ssh-copy-id -i ~/.ssh/id_rsa $USER@$KVM_HOST

#Testing the connection between MAAS and KVM-Host:
virsh -c qemu+ssh://$USER@$KVM_HOST/system list --all
read -n 1 -s -r -p "Do you see the vm nodes listed above ?[y/n]:" yn

if [[ yn == 'y' ]]
then
   echo "Communication between MAAS and KVM-Host is OK and good to go !!!"
   echo "*** Go and read - Add nodes via a Pod section (adding KVM VMs)... ***"
   echo "*** https://docs.maas.io/2.3/en/nodes-comp-hw ***"
   echo "*** user_name = User Name of KVM Host (ex. 'acd') ***"
   echo "*** ip_address = IP address of the host bridge (ex. br201 - 10.100.201.2)   ***"
   echo "*** At MAAS web UI do: ***"
   echo "*** Go to Pods menu and add pod ***"
   echo "*** Select Pod type to "Virsh virtual system"  ***"
   echo "*** Enter the Virsh address = "qemu+ssh://<user_name>@<ip_address>/system"  ***"
   echo "*** Save pod ***"
   printf " MAAS installation succeefully completed ... !!!\n"
   result 0
else
   echo "Communication failed !!! "
fi

# Exit from 'maas' user shell
exit

