#!/bin/bash
__acduroy__
#*****************************************************
# Description : A bash script to modify the Linux lsscsi utility.
# : To list SCSI devices and their attributes
# Usage : ./mylsscsi.sh
#*****************************************************
#declare global variables here
declare -ga diskname
echo
echo " Running modified lsscsi utility !!! "
echo
function getdevices(){
#*** declare variables ***
local -i nline # total lines with 'disk' word content in lsscsi command
local -i ptrline # pointer to the current line
local -i i # number of disk/s found
local -a tmpdiskname # array of disk devices
#*** count all disk devices in the system ***
nline=$(lsscsi |grep disk |grep 5:0 |wc -l)
#* for loop to populate array disk ***
if [ $nline -eq 1 ]
then
diskname[0]=$(lsscsi |grep disk |cut -c 59-61)
i=1
else
nline=$nline-1
for ((i=0; i <= $nline; i++))
do
ptrline=i+1
device=$(lsscsi |grep disk |head -n $ptrline |tail -n 1 |cut -c 59-61)
tmpdiskname+=("$device")
done
fi
#*** display all disk devices ***
#echo $i
#echo ${diskname[@]}
diskname="$(declare -p tmpdiskname)"
main
exit 1
}
function getserialnumber(){
serial=$(sg_inq /dev/$1 |grep -w "serial number:" |cut -c 21-43)
echo $serial
exit 1
}
function getcapacity(){
capacity=$(sg_readcap /dev/$1 |grep -w "Device size" |cut -c 16-60)
echo $capacity
exit 1
}
function main(){
local -i numdevices
local -i ptrnewline
local -i start
# *** program encountered fatal error ***
if [ $? -ne 0 ]
then
echo "$0: fatal error:" "$@" >&2
exit 1
else
#get number of physical disk(s) found in the system
numdevices=$(lsscsi |grep disk |grep 5:0 |wc -l)
echo $numdevices " Physical device(s) found !!!"
eval "declare -a NEWLIST=${diskname#*=}"
echo "Device Name of Physical Disk(s): " "${NEWLIST[@]}"
if [ $numdevices -eq 1 ]
then
echo "sda"
serialnumer=$(getserialnumber "sda")
capacity=$(getcapacity "sda")
lsscsicmd=$(lsscsi |grep disk)
echo $lsscsicmd $serialnumber $capacity
else
start=1
for disk in ${!NEWLIST[*]} # ((i=0; i <= $start; i++))
do
#echo "$disk: ${NEWLIST[$disk]}"
ptrnewline=i+1
serialnumber=$(getserialnumber ${NEWLIST[disk]})
capacity=$(getcapacity ${NEWLIST[disk]})
lsscsicmd=$(lsscsi |grep disk |head -n $start|tail -n 1)
echo $lsscsicmd $serialnumber $capacity
start=$start+1
done
fi
fi
exit 1
}
getdevices
