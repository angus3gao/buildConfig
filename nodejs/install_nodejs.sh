#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear

wget -c http://nodejs.org/dist/v4.2.6/node-v4.2.6.tar.gz

tar zxvf node-v4.2.6.tar.gz

cd node-v4.2.6

./configure

make

make install

node --version
npm --version
