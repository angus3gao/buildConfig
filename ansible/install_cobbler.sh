#!/bin/bash
# 安装cobbler

# 安装源
rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm

# 安装cobbler 及依赖
yum install -y httpd dhcp tftp cobbler cobbler-web pykickstart xinetd
