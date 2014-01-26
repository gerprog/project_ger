#!/bin/bash
# this unit test is within the tests folder
# the bash script isListening80.sh will be run and the result will 
# be logged to the port80_output.txt file in the logs folder
 . /home/testuser/project_ger/tests/isListening80.sh
  isTCPlisten 80 >> ../logs/port80_output.txt
 
