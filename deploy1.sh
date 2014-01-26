#!/bin/bash
cd /tmp
#
SANDBOX=sandbox_$RANDOM
mkdir $SANDBOX
cd $SANDBOX
ERRORCHECK=0
# Make test webpackage
mkdir webpackage
touch webpackage/index.htm
touch webpackage/form.htm
touch webpackage/script1.plx
touch webpackage/script2.plx
#
# Make the process directories
# these could be within the ITIL grouping of Service Transition and the sub-grouping of Asset Management
mkdir build
mkdir integrate
mkdir test
mkdir deploy
#
# Make webpackage and move webpackage
#
tar -zcvf webpackage_preBuild.tgz webpackage
MD5SUM=$(md5sum webpackage_preBuild.tgz | cut -f 1 -d' ')
PREVMD5SUM=$(cat /tmp/md5sum)
FILECHANGE=0
if [[ "$MD5SUM" != "$PREVMD5SUM" ]]
then
        FILECHANGE=1
        echo $MD5SUM not equal to $PREVMD5SUM
else
        FILECHANGE=0
        echo $MD5SUM equal to $PREVMD5SUM
fi
echo $MD5SUM > /tmp/md5sum
if [ $FILECHANGE -eq 0 ]
then
        echo no change in files, doing nothing and exiting
        # below we are moving forward to the log_monitor bash script
        #!/bin/sh
        . /home/testuser/project_ger/log_monitor1.sh
        exit
fi
# BUILD
# the preBuild zipped package is being moved to the build folder and unzipped
# there will be no errors in order to continue
mv webpackage_preBuild.tgz build
rm -rf webpackage
cd build
tar -zxvf webpackage_preBuild.tgz
#
tar -zcvf webpackage_preIntegrate.tgz webpackage
ERRORCHECK=0
# INTEGRATE
# the preIntegrate zipped package is being moved to the integrate folder and unzipped
# there will be no errors in order to continue
mv webpackage_preIntegrate.tgz ../integrate
rm -rf webpackage
cd ../integrate
#
tar -zxvf webpackage_preIntegrate.tgz
###
tar -zcvf webpackage_preTest.tgz webpackage
ERRORCHECK=0
# TEST
# the preTest zipped package is being moved to the test folder and unzipped
# there will be no errors in order to continue
mv webpackage_preTest.tgz ../test
rm -rf webpackage
cd ../test
#
tar -zxvf webpackage_preTest.tgz
###
tar -zcvf webpackage_preDeploy.tgz webpackage
ERRORCHECK=0
# DEPLOY
# if the amount of of errors is equal to or less than 0 then the process moves to 
# the preDeploy zipped package being moved to the deploy folder and unzipped

if [ $ERRORCHECK -eq 0 ]
then
        mv webpackage_preDeploy.tgz ../deploy
        rm -rf webpackage
        cd ../deploy
        tar -zxvf webpackage_preDeploy.tgz
fi



