#! /bin/bash

clear
echo "This script will build a MAAS OS Certification Server..."
before_reboot(){
	echo "Getting the update..."
	sudo apt-get update
	echo "Getting the dist-upgrade..."
	sudo apt-get dist-upgrade -y

	#reboot the computer
	echo "last_command" > last_command.txt
	reboot
}

after_reboot(){
	rm -f last_command.txt
        echo "adding repository ..."
	sudo apt-add-repository ppa:hardware-certification/public
	sudo apt-get update
        echo "installing the maas certification server..."
	sudo apt-get install maas-cert-server
	dpkg -s maas | grep Version
	
	# modify network interface
	clear
	ifconfig |grep -i link
	echo -n "Enter your external network interface [ens3]: ";read EXT
 	echo -n "Enter your internal network interface [ens8]: ";read INT
	echo "Now copying and modifying the maas cert config file..."
	sudo cp /etc/maas-cert-server/config /etc/maas-cert-server/config.org
        sudo sed -i -e "s/eth0/$INT/g" /etc/maas-cert-server/config
	sudo sed -i -e "s/eth1/$EXT/g" /etc/maas-cert-server/config
	
	# run the maniacs setup
	clear
	echo "Now setting up the maniac..."
	sudo maniacs-setup
}

# Determine if last command.txt exists
if [ -f last_command.txt ]; then
	# extract the last line out of the file
	last_command=$(head -n 1 last_command.txt)
	
	# check if last command is set
	if [ ! -z $last_command ]; then
		after_reboot
	fi
else
		before_reboot
fi	
