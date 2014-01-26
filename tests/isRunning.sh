#!/bin/bash
 isMysqlRunning() {
        isRunning mysqld
        return $?
}
# with this unit test we are looking if there are any instances of mySQL running
# if there are we have the amount plus the date and the time added to the log file in the logs folder
 isRunning() {
PROCESS_NUM=$(ps -ef | grep "$1" | grep -v "grep" | wc -l)
if [ $PROCESS_NUM -gt 0 ] ; then
        echo "There are" $PROCESS_NUM "instances of mySQL running on" $(date +"%F %T") 
        return 1
else
        return 0
fi
}
