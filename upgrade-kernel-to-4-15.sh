#! /bin/bash
#Upgrading the kernel 4.15 on Ubuntu 16.04
#ref: https://askubuntu.com/questions/1054742/ubuntu-16-04-and-kernel-4-15

# step 1:
# Add proposed repository to your Ubuntu 16.04 systems with kernel 4.13
echo -e "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" | sudo tee -a /etc/apt/sources.list.d/xenial-proposed.list

# step 2:
# Create file proposed-updates:
sudo touch /etc/apt/preferences.d/proposed-updates

# step 3:
# Open the created file in your favorite editor, let it be nano for instance:
# sudo nano /etc/apt/preferences.d/proposed-updates

# And add to the file this content:
# Package: *
# Pin: release a=xenial-proposed
# Pin-Priority: 400

# or using cat & tee command:
cat << PROPOSED | sudo tee -a /etc/apt/preferences.d/proposed-updates

Package: *
Pin: release a=xenial-proposed
Pin-Priority: 400

PROPOSED

# Save the file and Update && Upgrade
sudo apt update && sudo apt upgrade -y

# Find names of kernel packages available from proposed repository:
apt search linux-image | grep -i proposed

# Install desired kernel, e.g.
echo "Install the desired kernel; e.g."
echo " 'sudo apt install linux-image-4.15.0-26-generic/xenial-proposed' "
echo "Enter the desired kernel version ..."
read -p "Press [enter] to continue, [ctrl+c] to quit"

