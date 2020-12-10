#! /bin/bash

ADDRESSES="10.0.0.1 8.8.8.8 10.0.0.1 8.8.4.4 10.0.0.1 1.1.1.1 10.0.0.1 newsfrom.nowhere.com 10.0.0.1 www.cnn.com 10.0.0.1 www.google.com 10.0.0.1 www.xfinity.com"
pingResultseth0=' '
pingResultswlan0=' '
for((i=0; ;++i)); do
#    echo "loop number $i" >> pinglog 2>&1
#    date >> pinglog 2>&1
#    echo '++++++++++++++++++++++++++++++++++++++++++++++++++++'
    for a in $ADDRESSES
    do
	NOW=$( date '+%F_%H:%M:%S' )
#        echo 'Testing source interfac eth0: destination address:' $a
        ping -I eth0 -c 2 $a |grep packets > eth.txt
	value=`cat eth.txt`
#        echo "$value"
	IFS=' '
	read -r -a ADDR <<< "$value"
	if [ "${ADDR[6]}" = "packet" ]; then
		echo "$NOW" ",eth0" ",$a," "${ADDR[5]}" "," "${ADDR[9]}"
	else
		echo "$NOW" ",eth0" ",$a," "100%"
	fi		
        sleep 5.0
	NOW=$( date '+%F_%H:%M:%S' )
#        echo =====================================================
#        echo 'Testing source interfac wlan0: destination address:' $a
        ping -I wlan0 -c 2 $a |grep 'packets' > wifi.txt
	value=`cat wifi.txt`
#        echo "$value"
        IFS=' '
        read -r -a ADDR <<< "$value"
        if [ "${ADDR[6]}" = "packet" ]; then
        	echo "$NOW" ",wlan0" ",$a," "${ADDR[5]}" "," "${ADDR[9]}"
	else
		echo "$NOW" ",wlan0" ",$a," "100%"
	fi		
        sleep 10.0
#     done
    done  >> pinglog 2>&1

done 


