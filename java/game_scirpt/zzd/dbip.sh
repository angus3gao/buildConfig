#!/bin/bash
####该脚本仅用于获取db服务器列表
mysql -ss -e "select dbip from serverlist.serverlist where serverId >0 and serverId < 10000" > dblist
mysql -ss -e "select dbip from serverlist.serverlist2 where serverId >0 and serverId < 10000" > dblist2

