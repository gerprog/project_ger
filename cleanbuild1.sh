#!/usr/bin/bash
SANDBOX=sandbox_$RANDOM
echo Using sandbox $SANDBOX
#
# Stop services. This falls within the ITIL grouping of Service Design/Capacity Management
/etc/init.d/apache2 stop
/etc/init.d/mysql stop
#
apt-get update
#
# removing and installing Apache and mySQL falls within the ITIL grouping of 
# Service Design/Service Level Management and Availability Management
apt-get -q -y remove apache2
apt-get -q -y install apache2
#
# by creating a password we are maintaining Information Security
apt-get -q -y remove mysql-server mysql-client
echo mysql-server mysql-server/root_password password password | debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | debconf-set-selections
apt-get -q -y install mysql-server mysql-client
#
# cloning from github we can place in the ITIL grouping of Service Transition and the sub-groupings of 
# Transition Plan, Configuration Management and Asset Management. We can be confident of having 
# a clean installation
cd /tmp
mkdir $SANDBOX
cd $SANDBOX/
git clone https://github.com/gerprog/deployment_form
cd deployment_form/
#
cp Apache/www/* /var/www/
cp Apache/cgi-bin/* /usr/lib/cgi-bin/
chmod a+x /usr/lib/cgi-bin/*
#
# Start services
# here we are within the ITIL grouping of Service Operation and the sub grouping of Event Management
/etc/init.d/apache2 start
/etc/init.d/mysql start
#
# a database called dbtest is being created, to ensure a clean build it drops any existant tables and proceeds
# then to enter the customer details below - ITIL Service Transition/Asset Management.
# by setting the password we are witin ITIL Service Transition/Configuration Management
cat <<FINISH | mysql -uroot -ppassword
drop database if exists dbtest;
CREATE DATABASE dbtest;
GRANT ALL PRIVILEGES ON dbtest.* TO dbtestuser@localhost IDENTIFIED BY 'dbpassword';
use dbtest;
drop table if exists custdetails;
create table if not exists custdetails (
name         VARCHAR(30)   NOT NULL DEFAULT '',
address         VARCHAR(30)   NOT NULL DEFAULT ''
);
insert into custdetails (name,address) values ('Ger Daly','Here There'); select * from custdetails;
FINISH
#
cd /tmp
rm -rf $SANDBOX
# the next stage in the process is found and executed below
#sudo sh -x ./deploy1.sh
#!/bin/sh
. /home/testuser/project_ger/deploy1.sh
