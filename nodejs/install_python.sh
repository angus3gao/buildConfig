#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear
wget  http://li.nux.ro/download/nux/dextop/el6/i386/nux-dextop-release-0-2.el6.nux.noarch.rpm 
rpm -ivh nux-dextop-release-0-2.el6.nux.noarch.rpm

yum -y install python27yum -y install python27
yum -y install python27-devel

cd /usr/bin/   rm -rf python   cp python2.7 python 

python --version

sed -e "s/^#!/usr/bin/python$/#!/usr/bin/python2.6/" /usr/bin/yum
wget https://enterprise-storage-os.googlecode.com/files/setuptools-0.6c11.tar.gz
tar xzvf setuptools-0.6c11.tar.gz
cd setuptools-0.6c11
python setup.py install

