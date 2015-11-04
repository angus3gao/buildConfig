#!/bin/bash
#游戏服务器源ip
gameIp=$1
#数据库源服务器ip
dbIp=$2
#安装游戏服务器ip
toGameIp=$3
#安装数据库服务器Ip
toDbIp=$4
#腾讯服务器id
tencentid=$5
#游戏服务器id
serverid=$6
#flash 版本号
flashver=$7
if [ "$gameIp" == "$toGameIp" ];
then
  echo "sourceGameIp ${gameIp} equals toGameIp${toGameIp}"
 exit;
fi
if [ "$dbIp" == "$toDbIp" ];
then
  echo "sourceDbIp ${dbIp} equals toDbIp ${toDbIp} "
   exit;
fi
if [ "$gameIp" == "$toDbIp" ];
then
   echo "sourceGameIp ${gameIp} equals toDbIp ${toDbIp} "
  exit;
fi
if [ "$dbIp" == "$toGameIp" ];
then
   echo "sourceDbIp ${dbIp} equals toGameIp ${toGameIp} "
   exit;
fi
if [ "$tencentid" == "$serverid" ];
then
   echo "tencentid ${tencentid} equals serverid ${serverid} "
   exit;
fi
#添加到本地服务器列表
mysql -e "INSERT INTO serverlist.serverlist VALUES (${serverid},'${toGameIp}','${toDbIp}','${serverid}服')"
echo "将服务器id为:${serverid}||gameIP为:${toGameIp}||dbIp为${toDbIp} 插入服务器列表中"
#在发货服务器上添加 对应的服务器ip
fahuo1Ip='10.142.52.24'
fahuo2Ip='10.190.161.33'
fahuo3Ip='10.190.160.197'
ssh -p36000 ${fahuo1Ip} "mysql -e \"INSERT INTO qq_fahuo.qq_serverconfig VALUES ('${serverid}','${toGameIp}','80','/gameserverweb/qqtools/fahuo.jsp','${serverid}服',1)\""
ssh -p36000 ${fahuo2Ip} "mysql -e \"INSERT INTO qq_fahuo.qq_serverconfig VALUES ('${serverid}','${toGameIp}','80','/gameserverweb/qqtools/fahuo.jsp','${serverid}服',1)\""
ssh -p36000 ${fahuo3Ip} "mysql -e \"INSERT INTO qq_fahuo.qq_serverconfig VALUES ('${serverid}','${toGameIp}','80','/gameserverweb/qqtools/fahuo.jsp','${serverid}服',1)\""
ssh -p36000 ${fahuo1Ip} "mysql -e \"update qq_fahuo.dbcachelist set version=version+1 where cachename='qqserverconfig'\""
ssh -p36000 ${fahuo2Ip} "mysql -e \"update qq_fahuo.dbcachelist set version=version+1 where cachename='qqserverconfig'\""
ssh -p36000 ${fahuo3Ip} "mysql -e \"update qq_fahuo.dbcachelist set version=version+1 where cachename='qqserverconfig'\""
echo "将服务器id为:${serverid}||gameIP为:${toGameIp}||dbIp为${toDbIp} 插入发货服务器中"
#验证数据库 和 jdk 是否存在
if [ ! -f '/root/installpackage/mysql-5.1.53.tar.gz' ] ;then
echo "mysql 安装包 不存在 脚本退出！！！！"
  exit;
fi
if [ ! -f '/root/installpackage/mysql-5.1.53.tar.gz' ] ;then
echo "jdk 安装包不存在 脚本退出！！！！"
  exit;
fi
echo "======================start login ${toDbIp} dbserver install mysql==============="
#登陆到远程安装mysql
scp -P36000 -r /root/installpackage/mysql-5.1.53.tar.gz root@${toDbIp}:/tmp/
ssh -p36000 ${toDbIp} "/root/gamescript/mysql_install.sh" 
echo "======================install mysql end=========================================="
#DB和GAME远程安装JDK
echo "======================start login ${toDbIp} gameserver install jdk==============="
scp -P36000 -r /root/installpackage/jdk1.6.0_23.tar.gz root@${toDbIp}:/tmp/
ssh -p36000 ${toDbIp} "/root/gamescript/install_jdk.sh" 
echo "======================install jdk end=========================================="
echo "======================start login ${toGameIp} gameserver install jdk==============="
scp -P36000 -r /root/installpackage/jdk1.6.0_23.tar.gz root@${toGameIp}:/tmp/
ssh -p36000 ${toGameIp} "/root/gamescript/install_jdk.sh" 
echo "======================install jdk end=========================================="
ssh -p36000 ${toGameIp} "sh /root/gamescript/ulimit.sh"

rm -rf /tmp/jhserver.tar.gz
#服务器工程打包 游戏工程 并拷贝到本地
echo "从${gameIp} 拷贝服务器工程...... "
ssh -p36000 ${gameIp} "tar --exclude=jhserver/gameserver/webapps/gameserverweb/WEB-INF/runtimejar/* --exclude=jhserver/gameserver/logs/* --exclude=jhserver/gameserver/work/Catalina/localhost/* -C /usr/local/ -zcvf jhserver.tar.gz jhserver" 
scp -P36000 root@${gameIp}:/root/jhserver.tar.gz /tmp
if [ ! -f '/tmp/jhserver.tar.gz' ] ;then
echo "游戏程序不存在 脚本退出！！！！"
  exit;
fi
echo "从${gameIp} 拷贝服务器工程完毕"
#数据库打包 并 拷贝到本地
rm -rf /tmp/db.tar.gz
ssh -p36000 ${dbIp} "mysqldump --opt -d character>character.sql"
ssh -p36000 ${dbIp}  "mysqldump --opt -d account >account.sql"
ssh -p36000 ${dbIp}  "mysqldump --opt -d gamelog >gamelog.sql"
ssh -p36000 ${dbIp} "mysqldump gamedata >gamedata.sql"
ssh -p36000 ${dbIp} "tar -zcvf db.tar.gz character.sql account.sql gamelog.sql gamedata.sql"
scp -P36000 root@${dbIp}:/root/db.tar.gz /tmp
if [ ! -f '/tmp/db.tar.gz' ] ;then
echo "数据库脚本不存在 脚本退出！！！！"
  exit;
fi
echo "从${dbIp} 拷贝sql脚本完毕"
#将数据库拷贝到 数据库服务器
scp -P36000 -r /tmp/db.tar.gz root@${toDbIp}:/tmp/
#登陆数据库服务器安装数据库
ssh -p36000 ${toDbIp} "/root/gamescript/db_install.sh '${tencentid}' '${serverid}' '${toGameIp}' '${flashver}'"
#将游戏工程拷贝到游戏服务器
scp -P36000 -r /tmp/jhserver.tar.gz root@${toGameIp}:/tmp/
#登陆游戏服务器安装游戏
ssh -p36000 ${toGameIp} "/root/gamescript/game_install.sh '${serverid}' '${toDbIp}'"
#启动游戏服务器
ssh -p36000 10.190.169.45 "mysql -e \"INSERT INTO gamedata.across_game_server VALUES ('${serverid}','${toGameIp}',9528);\";"
ssh -p36000 10.190.169.45 "mysql -e \"update gamedata.dbcachelist set version=version+1 where  cachename='across_game_server'\";"
echo "脚本执行完毕!!!"
