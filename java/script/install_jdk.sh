#!/bin/bash
#ver
echo "=======================================开始下载jdk安装脚本=======================================";
cd /tmp/
tar zxvf jdk1.6.0_23.tar.gz -C /usr/local/
ln -s /usr/local/jdk1.6.0_23 /usr/local/jdk
#set jdk
cat >>/etc/profile<<EOF
export JAVA_HOME=/usr/local/jdk
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$PATH:$JAVA_HOME/bin
EOF
#
rm -rf /usr/bin/java
ln -s /usr/local/jdk1.6.0_23/bin/java /usr/bin/
source /etc/profile
echo "=======================================java环境配置完成=======================================";