#!/bin/bash
version=$1
cd /usr/local/
echo "开始下载服务器程序升级包(webapps.zip)"
rm -rf /usr/local/zjupdategame*
mkdir /usr/local/zjupdategame${version}
cd /usr/local/zjupdategame${version}
wget --cut-dirs=3 http://10.204.146.146:7890/${version}/webapps.zip
filepath=/usr/local/zjupdategame${version}/webapps.zip
gameid=$(cat /usr/local/jhserver/gameserver/conf/serverparam.properties|sed -n '2p'|awk -F'=' '{print $2}')
if [ ! -f "$filepath" ]; then 
 echo `date +%F~%H:%M`" "${gameid}"服游戏 下载文件失败" >/home/update.log
 exit;
fi 
echo ${gameid}"服游戏下载完成"
echo `date +%F~%H:%M`" "${gameid}"服游戏 下载文件成功" >/home/update.log
