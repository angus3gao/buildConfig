#!/bin/bash
falg=$1
serverids=$2
rm -fr /root/slist/*
if [ "$falg" == "NOTIN" ];then
  mysql -ss -e "select gameIp from serverlist.serverlist where serverId not in (${serverids})"> /root/slist/gameiplist
 echo "除"${serverids}"服务器外 所有游戏列表Ip导出完成"
 cat /root/slist/gameiplist
 mysql -ss -e "select dbip from serverlist.serverlist where serverId not in (${serverids})" > /root/slist/dblist
 echo "除${serverids} 服务器外 所有数据库列表Ip导出完成"
 cat /root/slist/dblist
 exit;
fi
if [ "$falg" == "IN" ]; then
  mysql -ss -e "select gameIp from serverlist.serverlist where serverId in (${serverids})"> /root/slist/gameiplist
 echo "导出${serverids} 游戏列表IP完成"
 cat /root/slist/gameiplist
 mysql -ss -e "select dbip from serverlist.serverlist where serverId in (${serverids})" > /root/slist/dblist
 echo "导出${serverids} 数据库列表IP完成"
 cat /root/slist/dblist
 exit;
fi
if [ "$falg" == "ALL" ]; then
  mysql -ss -e "select gameIp from serverlist.serverlist"> /root/slist/gameiplist
 echo "导出所有 游戏列表IP完成"
 cat /root/slist/gameiplist
 mysql -ss -e "select dbip from serverlist.serverlist" > /root/slist/dblist
 echo "导出所有 数据库列表IP完成"
 cat /root/slist/dblist
 exit;
fi
echo "参数错误 正确参数如下"
echo "如果 (除了某台) 服务器全导出则 ./list NOTIN 服务器id以,分割"
echo "如果 (只导出)   某几台服务器则 ./list IN 服务器id以,分割 "
echo "如果 (全部)     导出 则 ./list ALL"
