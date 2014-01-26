#!/bin/bash
# this unit test is within the tests folder
# the bash script isRunning.sh will be run and the result will 
# be logged to the mySQLoutput.txt file in the logs folder
 . /home/testuser/project_ger/tests/isRunning.sh
  isRunning mysqld >> ../logs/mySQLoutput.txt
 
