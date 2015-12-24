#!/bin/bash
version=$1
cd /usr/local/
echo "开始下载服务器程序升级包(webapps.zip)"
rm -rf /usr/locala/game*
mkdir /usr/locala/game${version}
cd /usr/local/game${version}
wget --cut-dirs=3 http://192.168.1.127:7890/${version}/webapps.zip
filepath=/usr/local/zjupdategame${version}/webapps.zip
gameid=$(cat /usr/local/server/conf/serverparam.properties|sed -n '2p'|awk -F'=' '{print $2}')
if [ ! -f "$filepath" ]; then 
 echo `date +%F~%H:%M`" "${gameid}"服游戏 下载文件失败" >/home/update.log
 exit;
fi 
echo ${gameid}"服游戏下载完成"
echo `date +%F~%H:%M`" "${gameid}"服游戏 下载文件成功" >/home/update.log
