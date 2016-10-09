#!/bin/bash
# 配置路径
ansible_dir='/etc/ansible'

if [ ! -f "${ansible_dir}" ]; then 
    mkdir ${ansible_dir}
fi

cp hosts.inventory ${ansible_dir}/hosts

ssh-agent bash
ssh-add ~/.ssh/id_rsa
