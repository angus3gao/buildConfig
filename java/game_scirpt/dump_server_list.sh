#!/bin/bash
flag=$1
serverids=$2
rm -rf /data/log/slist/*
#  这里需要中每个指令之间有空格 如["flag 会出现错误
if [ "$flag" == "NOTIN" ]; then
#此处 -e 必须参数， -ss 是使用登陆ssh的用户和密码登陆数据库
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist where serverId not in ($serverids)" > /data/slist/gameiplist
 echo "除"$serverids"服务器外 所有游戏列表Ip导出完成"
 cat /data/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbIp from serverlist.serverlist where serverId not in ($serverids)" > /data/slist/dblist
 echo "除"$serverids"服务器外 所有数据库列表Ip导出完成"
 cat /data/slist/dblist
 exit;
fi
if [ "$flag" == "IN" ]; then 
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist where serverId in ($serverids)" > /data/slist/gameiplist
 echo "导出"$serverids"游戏列表Ip导出完成"
 cat /data/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbIp from serverlist.serverlist where serverId in ($serverids)" > /data/slist/dblist
 echo "导出"$serverids"数据库列表Ip导出完成"
 cat /data/slist/dblist
 exit;
fi
if [ "$flag" == "ALL" ]; then 
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist"> /root/slist/gameiplist
 echo "导出所有 游戏列表Ip完成"
 cat /root/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbip from serverlist.serverlist" > /root/slist/dblist
 echo "导出所有 数据库列表IP完成"
 cat /root/slist/dblist
 exit;
fi 
echo "参数错误 正确参数如下"
echo "如果(除了某台)服务器全导出则 ./list NOTIN 服务器id以,分割"
echo "如果(只导出) 某几台服务器则 ./list IN 服务器id,分割"
echo "如果(全部) 导出 则 ./list ALL"