#! /bin/bash
clear
echo -e "\e[3J"	#disable scroll

usage(){
	clear
	echo "Usage $0 github-setup"
	echo "Ex: $ bridge-networking"
	exit 1
}



# git configuration setup #
git config --global user.name "acduroy"
git config --global user.mail "acduroy@yahoo.com"
git config --global color.ui auto

# call usage() if directory name is not supplied #
[[ $# -eq 0 ]] && usage


# create repositories #
mkdir $1
cd $1
git init 
git clone https://github.com/acduroy/$1.git

exit 0

