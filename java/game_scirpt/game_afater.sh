#!/bin/bash
version=$1
#######停止游戏服务器######
 echo "开始关闭游戏服务"
 curl http://127.0.0.1/gameserverweb/gm/ip_shutdown.jsp&
 echo "开始等待服务器关闭300秒延迟"
 sleep 300
##########强制关闭服务器################################
echo "开始强制关闭游戏服务器"
kill -9 `ps aux |grep -i gameserver |grep -v grep |awk '{print $2}'`
echo "开始 /usr/local/jhserver 目录 赋予读写执行权限"
chmod -R 700 /usr/local/jhserver*
mkdir -p /usr/local/dbback/${version}back
cd /usr/local/dbback/${version}back
tar -zcvf  gameserver.tar.gz /usr/local/jhserver/gameserver/
echo "======================================程序打包完毕=======================================";
gameid=$(cat /usr/local/jhserver/gameserver/conf/serverparam.properties|sed -n '2p'|awk -F'=' '{print $2}')
filepath=/usr/local/zjupdategame${version}/webapps.zip
if [ ! -f "$filepath" ]; then 
 echo `date +%F~%H:%M`" "${gameid}"服 没有更新服务器" >> /home/update.log
 exit;
fi 
echo "开始更新服务器程序。。。"
rm -rf /usr/local/jhserver/gameserver/webapps*
mv /usr/local/zjupdategame${version}/webapps.zip /usr/local/jhserver/gameserver/
cd /usr/local/jhserver/gameserver/
unzip -o webapps.zip
rm -rf /usr/local/jhserver/gameserver/work/Catalina/localhost/*
rm -fr /usr/local/jhserver/gameserver/logs/*
chmod 777 /usr/local/jhserver/gameserver/bin/*.sh
echo "更新完成"
echo `date +%F~%H:%M`" "${gameid}"服游戏 更新服务器成功" >> /home/update.log