#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear

# download page for MySQL Yum repository at http://dev.mysql.com/downloads/repo/yum/.
wget -c http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm

# Install the downloaded release package with the following command, replacing platform-and-version-
sudo rpm -Uvh mysql-community-release-el6-5.noarch.rpm

# Use this command to see all the subrepositories in the MySQL Yum repository, and see which of them are enabled or disabled:
yum repolist all | grep mysql

# Verify that the correct subrepositories have been enabled and disabled by running the following command and checking its output:
yum repolist enabled | grep mysql

# Installing MySQL with Yum
# This installs the package for the MySQL server, as well as other required packages.
sudo yum install mysql-community-server

service mysqld start

#grant select,insert,update,delete on *.* to root@'%' Identified by "view!3344"
