#!/bin/bash
# Main Menu Script 

function menu {
   clear
   printf 'Please enter your choice:\n'
   options=("Enable NAT" "Install MAAS" "Install JUJU" "Quit")
   select opt in "${options[@]}"
   do
       case $opt in
          "Enable NAT")
	     clear
             echo "Enablement of NAT"
	     nat-enable
             return 1
	     ;;
         "Install MAAS")
             clear
             echo "Installing maas, this takes time pls wait thanks ..."
	     maas-install
             return 2
             ;;
         "Install JUJU")
	     clear
             echo "Installing juju for cloud deployment"
	     juju-install
             return 3
             ;;
         "Quit")
             return 0
             exit      
             ;;
         *) echo invalid option;;
       esac
   done
}

function nat-enable {
   if [[ $? -eq 0 ]]
   then		
      sh ./nat-enable-only.sh
      read -n 1 -s -r -p "NAT was enabled successfully, press any key to continue: "
   else
      echo "command error"
   fi
}

function maas-install {
   echo "installing maas now, this may take time thanks ..."
}
 
function juju-install {
   echo "installing juju now, this may take time thanks ..."
}
  
function main {
      menu
      while [ $? -gt 0 ]; do
         menu
      done
}      
 
main   
