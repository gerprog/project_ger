 #!/bin/bash
 isMyqlListening() {
        isTCPlisten 3306
        return $?
}

# with this unit test we are looking if TCP is listening for mySQL on port 3306
# if so we have the date and the time added to the log file in the logs folder
 isTCPlisten() {
TCPCOUNT=$(netstat -tupln | grep tcp | grep "$1" | wc -l)
if [ $TCPCOUNT -gt 0 ] ; then
	 	echo "The port 3306 is listening for mySQL on" $(date +"%F %T") 
        return 1
else
        return 0
fi
}


