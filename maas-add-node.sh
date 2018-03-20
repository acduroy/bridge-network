#!/bin/bash

# Prerequisite: MAAS by now installation is completed
# MAAS with KVM 
# ref: https://docs.maas.io/2.3/en/nodes-add
# The procedure below is to add nodes via a Pod 

# At MAAS node do:
echo "*** Installing libvirt-bin... ***"
sudo apt install libvirt-bin -y

# Generating SSH private/pub key 'maas' user.. (in case no private/pub key generated)
# Remember this is key pair for 'maas' user!!!!
echo "*** Generating SSH Key for 'maas' superuser ... ***"
sudo chsh -s /bin/bash maas
sudo su - maas
ssh-keygen -f ~/.ssh/id_rsa -N ''

# Copy public key to the target node (from MAAS to KVM host in this case)
# Remember this is still under 'mass' user shell/console!!!
echo "*** Copying SSH keys ... ***"
echo -n "Enter KVM Host user name:[ex. acd] "; read USER
echo -n "Enter KVM Host internal ip address:[ex. 10.100.201.2] "; read KVM_HOST
ssh-copy-id -i ~/.ssh/id_rsa $USER@$KVM_HOST

# Testing connection between MAAS and KVM-Host:
echo "*** Testing the connection ... ***"
virsh -c qemu+ssh://$USER@$KVM_HOST/system list --all

# Exit from 'maas' user shell
exit

# Go and read - Add nodes via a Pod section (adding KVM VMs)...
# ref: https://docs.maas.io/2.3/en/nodes-comp-hw
# go to http://$MAAS_IPADDR:5240/MAAS/#/pods
# virsh address format ex. qemu+ssh://$USER@$KVM_HOST/system 

