#!/bin/bash
# 安装地址参数
prefix_dir=$1

#git clone git://github.com/ansible/ansible.git --recursive

if [ -f "$filepath" ]; then 
 echo `date +%F~%H:%M`"ansible 已安装。"
 exit;
fi

# 从github 上获取 ansible 源码
git clone git://github.com/ansible/ansible.git ${prefix_dir}/ansible --recursive
cd ${prefix_dir}/ansible
# 设置环境变量 
source ./hacking/env-setup

git pull --rebase
git submodule update --init --recursive

cd /tmp/
#安装 pip
sudo easy_install pip
#安装ansible 相关依赖模块 
sudo pip install paramiko PyYAML Jinja2 httplib2 six

