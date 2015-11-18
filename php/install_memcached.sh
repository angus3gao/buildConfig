#!/bin/bash


libe_ver="2.0.22-stable"
#wget -c https://github.com/downloads/libevent/libevent/libevent-${libe_ver}.tar.gz
tar -zxf libevent-${libe_ver}.tar.gz
cd libevent-${libe_ver}
./configure --prefix=/usr
make && make install

memc_ver="1.4.0"
#wget -c http://www.danga.com/memcached/dist/memcached-${memc_ver}.tar.gz


tar -zxf memcached-${memc_ver}.tar.gz
cd memcached-${memc_ver}

./configure --prefix=/usr/local/memcached --with-libevent=/usr/local/libevent/

make && make install
