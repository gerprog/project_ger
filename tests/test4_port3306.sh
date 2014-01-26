#!/bin/bash
# this unit test is within the tests folder
# the bash script isListening3306.sh will be run and the result will 
# be logged to the port3306_output.txt file in the logs folder
 . /home/testuser/project_ger/tests/isListening3306.sh
  isTCPlisten 3306 >> ../logs/port3306_output.txt
 
