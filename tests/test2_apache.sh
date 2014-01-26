#!/bin/bash
# this unit test is within the tests folder
# the bash script isRunningApache.sh will be run and the result will 
# be logged to the apache_output.txt file in the logs folder
 . /home/testuser/project_ger/tests/isRunningApache.sh
  isRunning apache2 >> ../logs/apache_output.txt
 
