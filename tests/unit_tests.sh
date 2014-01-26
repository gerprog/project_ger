#!/bin/bash
# these are all the unit tests within the tests folder
# the relevant bash scripts will be run and the results will 
# be logged to the unit_tests_output.txt file in the logs folder
 . /home/testuser/project_ger/tests/isRunning.sh
  isRunning mysqld > ../logs/unit_tests_output.txt
 
 . /home/testuser/project_ger/tests/isRunningApache.sh
  isRunning apache2 > ../logs/unit_tests_output.txt
 
 . /home/testuser/project_ger/tests/isListening80.sh
  isTCPlisten 80 > ../logs/unit_tests_output.txt
  
  . /home/testuser/project_ger/tests/isListening3306.sh
  isTCPlisten 3306 > ../logs/unit_tests_output.txt
 
