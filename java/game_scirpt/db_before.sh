#!/bin/bash
version=$1
cd /usr/local/
rm -rf /usr/local/zjupdatedb*
mkdir /usr/local/zjupdatedb${version}
cd /usr/local/zjupdatedb${version}
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
filepath=/usr/local/zjupdatedb${version}/db_update.zip
wget http://10.204.146.146:7890/${version}/db_update.zip
if [ ! -f "$filepath" ]; then 
 echo `date +%F~%H:%M`" "${gameid}"服数据库 下载失败" >/home/update.log
 exit;
fi 
unzip db_update.zip
echo ${gameid}"服DB下载完成"
echo `date +%F~%H:%M`" "${gameid}"服数据库 下载成功" >/home/update.log