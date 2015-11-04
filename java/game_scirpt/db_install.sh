#!/bin/sh -
#腾讯对应的id
tencentid=$1
#游戏服务器id
serverid=$2
#游戏服务器ip
serverIp=$3
#flash 版本号
flashver=$4
#平台id 固定
deptid=1005

echo "=======================================开始构建安装目录=======================================";
cd /tmp/;
echo "=======================================开始解压数据库文件=======================================";
#lftp -u app100625638,zuijian123 cvmftp.tencentyun.com:53000 -e 'get gameinstall/db.tar.gz; quit'
tar -zxvf db.tar.gz;
echo "=======================================数据库解压完毕=======================================";
echo "=======================================开始创建数据库=======================================";
mysql -e "create database if not exists gamedata";
mysql -e "create database if not exists \`character\`";
mysql -e "create database if not exists account";
mysql -e "create database if not exists gamelog";
echo "=======================================授权后台访问=======================================";
mysql -e "grant drop,create,select,insert,update,delete on *.* to 'developer'@'${serverIp}' IDENTIFIED by 'helloworld' with grant option;";
echo "=======================================开始还原数据库=======================================";
mysql gamedata < gamedata.sql;
printf "gamedata导入完成\n";
mysql character < character.sql;
printf "character导入完成\n";
mysql account < account.sql;
printf "account导入完成\n";
mysql gamelog < gamelog.sql;
printf "gamelog导入完成\n";
echo "=======================================配置数据=======================================";
 domainName="s${tencentid}.app100625638.qqopenapp.com"
echo ${domainName}
mysql -e "delete from gamedata.server_list where loginServerId!=${serverid}";
mysql -e "INSERT INTO gamedata.server_list VALUES ('${serverid}',3000,'${serverid}服','${domainName}','443','${domainName}','443','http://jh.178tc1.com/eflashdir/flashClient','${flashver}',NULL,'http://10.190.168.98/qqgift/toGiftCheck.do');";
mysql -e "delete from gamedata.lineserver";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',1,'醉剑一线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',2,'醉剑二线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',3,'醉剑三线',1);";
mysql -e "INSERT INTO gamedata.serverid_transition VALUES ('${tencentid}','${serverid}','${serverid}服');";
echo "=======================================数据库安装完成=======================================";
