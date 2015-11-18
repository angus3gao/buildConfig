#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear

wget -c http://nodejs.org/dist/v0.10.29/node-v0.10.29.tar.gz

tar zxvf node-v0.10.29.tar.gz

cd node-v0.10.29

./configure

make

make install

node --version
npm --version
