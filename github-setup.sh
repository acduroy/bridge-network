#!/bin/bash

clear
echo -e "\e[3J"	#disable scroll

usage(){
	clear
	echo "Usage $0 github-setup"
	echo "repositoriy name was not supplied"
	echo "Ex: ./github-setup.sh <name of the repository>"
	exit 1
}

# check if repository name is supplied in the command line #
# if not call usage() function #
[[ $# -eq 0 ]] && usage

# install git package #
sudo apt-get install git -y

# git configuration setup #
git config --global user.name "acduroy"
git config --global user.email "acduroy@yahoo.com"
git config --global color.ui auto

# create repositories in home directory #
cd $PWD
git clone https://github.com/acduroy/$1.git

exit 0
