#!/bin/bash

#sh install_git_before.sh

tar -zxf git-1.7.6.tar.gz
cd git-1.7.6
make prefix=/usr/local all
sudo make prefix=/usr/local install

#配置
git config --global user.name "angus3gao"
git config --global user.email gaosi_angus@163.com
