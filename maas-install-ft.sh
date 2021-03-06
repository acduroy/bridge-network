#!/bin/bash

# Prerequisite: Ubuntu Server OS installed on MAAS server in this case 16.04 LTS release
# Below steps is a fresh install of maas using packages 
# Ref: https://docs.maas.io/2.3/en/installconfig-package-install

# At MAAS server do:
# Execute command at home directory

#clear display
clear

# Enabling the NAT 
printf "The script will enable the NAT !!!\n" 
while true; do
     read -p "Do you want to proceed[y/n]?" yn
     case $yn in
     	[Yy]* ) 
		if [ $? -eq 0 ]
		then
	      	   sh ./nat-enable-only.sh
 		else
		   echo "command error !!!"
		   exit 1
		fi
		break
		;;
     	[Nn]* ) 
		exit
		;;
     	* ) 
		echo "Please answer yes or no.";;
     esac
done

clear #clear display
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
clear
# Alternative way to create MAAS user with script
# ex. username = "vmaas201", password = "Super123"
echo "*** Creating admin maas user ***"
echo -n "Enter username[ex. maas]: "; read PROFILE
echo -n "Enter email[ex. acduroy@yahoo.com] "; read EMAIL_ADDRESS
#
#sudo maas createadmin --username=$PROFILE --emaail=$EMAIL_ADDRESS
#
## Generating SSH Key
#echo "Generate SSH public key..."
#ssh-keygen -f ~/.ssh/id_rsa -N ''
#
# Copy public key to the target node (from MAAS to KVM host in this case)
# Remember this is still under 'mass' user shell/console!!!
#echo -n "Enter KVM Host user name[ex.acd]: "; read USER
#echo -n "Enter KVM Host internal ip address[ex.10.100.201.2]: "; read KVM_HOST
#ssh-copy-id -i ~/.ssh/id_rsa $USER@$KVM_HOST
