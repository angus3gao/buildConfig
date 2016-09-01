#!/bin/bash

if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this tool!\n"
    exit 1
fi
clear


cat >>/etc/yum.repos.d/wandisco-svn.repo<<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF

yum clean all

yum -y install subversion

svn --version