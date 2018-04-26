#! /bin/bash

TIME=$1
LOGFILE=$2
for i in {1..4}
do 
    echo "Test number #$i"
    iperf3 -c 10.100.209.50 -t $TIME --logfile $LOGFILE
done
echo "Testing is completed !!!" 

