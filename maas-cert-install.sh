#! /bin/bash

# Function before reboot
before_reboot(){
	cd
	echo "Getting the update..."
	sudo apt-get update
	echo "Getting the dist-upgrade..."
	sudo apt-get dist-upgrade -y
}

# Function after reboot
after_reboot(){
	cd
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

# Enable autostart function
enable_autostart(){
	# go to home directory and backup .bashrc file
	cd 
	cp .bashrc .bashrc.orig
	
	# insert the script inside .bashrc file  to run at login
	INS_STRING="source ./maas-cert-install.sh"
	echo "$INS_STRING" >> .bashrc
}

# Disable autostart function
disable_autostart(){
	# go to home directory and fetch the last line in .bashrc file
        cd 
	LAST_LINE=$(tail -n 1 .bashrc)
        
	# search the file if autoscript is attached
	if [[ $LAST_LINE == "source ./maas-cert-install.sh" ]]; then
  		# if found, delete the autostart script in the file
		# Need to delimit the search inorder sed to work
		# Ref: ://stackoverflow.com/questions/35157623/
		# how-to-to-delete-a-line-given-with-a-variable-in-sed
                sed -i "/${LAST_LINE/\//\\/}/d" .bashrc
	else
		echo "Sorry, no such string found in the file ...."
	fi
}

start_message(){
if [[ -f last_command.txt ]]; then
	echo "found last_command.txt ..."
	return
fi
clear
echo "This script will build a MAAS OS Certification Server..."
echo "Does the MAAS Server has two NIC interfaces available ? [Y/n]: ";read USER_INPUT
USER_INPUT=$(echo $USER_INPUT | awk '{print toupper($0)}')
if [[ $USER_INPUT == "Y" ]]
then
    echo "****************************************************************************"
    echo "*                                                                          *"
    echo "* Pls ensure that the internal NIC is hook-up to the internal MAAS network *"
    echo "* While the external NIC is hook-up to the IT network. Thank you !!!       *"
    echo "*                                                                          *"   
    echo "****************************************************************************"
    read -p "Press enter key to proceed ..."
else
   echo " Halting MAAS installation, needs to configure first the MAAS server accordingly. Thanks !!!"
   exit
fi
}

# Main Program starts here...
disable_autostart # to eliminate continuous loop

# check if last_command file exist in the home directory
cd
if [[ -f last_command.txt ]]; then
	
	# Delete the last_command file after reboot and disable autostart script
        rm -f ~/last_command.txt
	disable_autostart
	
	# Call after_reboot function
        after_reboot
else
	start_message
	# Create last_command.txt file and enable autostart script
        touch ~/last_command.txt
	enable_autostart
	
	# Call before_reboot function 
	before_reboot

        echo "Do you want to reboot now? [Y/n]: "; read REBOOT
        REBOOT=$(echo $REBOOT | awk '{print toupper($0)}')
        if [[ $REBOOT == "Y" ]]; then
		echo "The system is now rebooting ..."
        	sudo reboot
	else
		echo "Remember to continue the MAAS installation, need to reboot the system !!! Thanks..."
   		exit
	fi
fi	 
