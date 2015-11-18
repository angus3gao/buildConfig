#!/bin/bash
#set env
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH
#install need root user.
if [ `whoami` != "root" ];then
        echo "Installtion this package needs root user."
        exit 1
fi
#ver
cmake_ver="2.8.7"
#wget  http://www.cmake.org/files/v2.8/${cmake_ver}.tar.gz

#complier mysql
cd /tmp/

tar zxvf cmake-${cmake_ver}.tar.gz
cd cmake-${cmake_ver}

#install 

./configure && make && make install 


