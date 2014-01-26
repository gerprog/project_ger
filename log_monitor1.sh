#!/bin/bash
# fslyne 2013
# below is the email address for the administrator
ADMINISTRATOR=bigmarker14@gmail.com
MAILSERVER=smtp.gmail.com


# Level 1 functions <---------------------------------------
# checks in place that all services are running. This process would be within the ITIL grouping of
# Service Design and the sub-groupings of Service Level Management and Availability Management.

 isApacheRunning() {
        isRunning apache2
        return $?
}
# Apache must be listening on port 80
 isApacheListening() {
        isTCPlisten 80
        return $?
}
# mySQL must be listening on port 3306
 isMyqlListening() {
        isTCPlisten 3306
        return $?
}

 isApacheRemoteUp() {
        isTCPremoteOpen 127.0.0.1 80
        return $?
}

 isMysqlRunning() {
        isRunning mysqld
        return $?
}


# Level 0 functions <--------------------------------------
# below checks a process is running it is being applied to the isMysqlRunning and isApacheRunning functions
# reporting and compiling of errors would fall under the ITIL grouping of Service Operation within the
# sub-grouping of Problem Management
 isRunning() {
PROCESS_NUM=$(ps -ef | grep "$1" | grep -v "grep" | wc -l)
if [ $PROCESS_NUM -gt 0 ] ; then
        echo $PROCESS_NUM
        return 1
else
        return 0
fi
}

# below checks a TCP port is open it is being applied to the isMysqlListening and isApacheListening functions
# we are piping some commands one after the other. 
# looking at every instance of tcp we count how many times it is found running
# if the result is greater than 0 then we will have the number 1 returned to log
# otherwise we will have 0 returned

 isTCPlisten() {
TCPCOUNT=$(netstat -tupln | grep tcp | grep "$1" | wc -l)
if [ $TCPCOUNT -gt 0 ] ; then
        return 1
else
        return 0
fi
}
# we are piping some commands one after the other. 
# looking at every instance of udp we count how many times it is found running
# if the result is greater than 0 then we will have the number 1 returned to log
# otherwise we will have 0 returned
 isUDPlisten() {
UDPCOUNT=$(netstat -tupln | grep udp | grep "$1" | wc -l)
if [ $UDPCOUNT -gt 0 ] ; then
        return 1
else
        return 0
fi
}

# if the TCP remote is open we will have /dev/tcp/$1/$2 returned with 1 or 0
 isTCPremoteOpen() {
timeout 1 bash -c "echo >/dev/tcp/$1/$2" && return 1 ||  return 0
}

# the pings sent and received are counted if the count is greater than 0 then 1 is logged
# otherwise 0 is logged
 isIPalive() {
PINGCOUNT=$(ping -c 1 "$1" | grep "1 received" | wc -l)
if [ $PINGCOUNT -gt 0 ] ; then
        return 1
else
        return 0
fi
}
# there is a threshold being set of 5MB of space needed for the CPU. 
# If the reading is greater than the limit 0 is returned to log otherwise 1 is returned.
 getCPU() {
app_name=$1
cpu_limit="5000"
app_pid=`ps aux | grep $app_name | grep -v grep | awk {'print $2'}`
app_cpu=`ps aux | grep $app_name | grep -v grep | awk {'print $3*100'}`
if [[ $app_cpu -gt $cpu_limit ]]; then
     return 0
else
     return 1
fi
}


ERRORCOUNT=0

# Functional Body of monitoring script <----------------------------
# below the relevant results are output with the echo command to the terminal window and written to the 
# log file when necessary. If a process is not running the errorcount is also output.
isApacheRunning()
if [ "$?" -eq 1 ]; then
        echo Apache process is Running
else
        echo Apache process is not Running
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isApacheListening()
if [ "$?" -eq 1 ]; then
        echo Apache is Listening
else
        echo Apache is not Listening
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isApacheRemoteUp()
if [ "$?" -eq 1 ]; then
        echo Remote Apache TCP port is up
else
        echo Remote Apache TCP port is down
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isMysqlRunning()
if [ "$?" -eq 1 ]; then
        echo Mysql process is Running
else
        echo Mysql process is not Running
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isMysqlListening()
if [ "$?" -eq 1 ]; then
        echo Mysql is Listening
else
        echo Mysql is not Listening
        ERRORCOUNT=$((ERRORCOUNT+1))
fi

isMysqlRemoteUp()
if [ "$?" -eq 1 ]; then
        echo Remote Mysql TCP port is up
else
        echo Remote Mysql TCP port is down
        ERRORCOUNT=$((ERRORCOUNT+1))
fi
# if all errorcounts are equal to 0 then "There are no problems. Deployment was clean." is output to log
# and the process uses the script sendmail.pl to create an email to send to the administrator
# otherwise if there is an error count of 1 or more then "There are problems with the deployment."
# will be output to log and the process will use the script sendmail_error.pl to send the error message to
# the administrator to notify of the issue.
# reporting and compiling of errors would fall under the ITIL grouping of Service Operation within the
# sub-groupings of Incident and Problem Management
if  [ $ERRORCOUNT -eq 0 ]
then
        echo "There are no problems. Deployment was clean." | perl /home/testuser/project_ger/sendmail.pl $ADMINISTRATOR $MAILSERVER

else
        echo "There are problems with the deployment." | perl /home/testuser/project_ger/sendmail_error.pl $ADMINISTRATOR $MAILSERVER
fi


 . /home/testuser/project_ger/unit_tests.sh
