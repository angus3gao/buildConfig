#!/bin/sh -
#是否升级gamedata库
gamedata=$1
#是否升级character判断
character=$2
#是否升级account判断
account=$3
#是否升级gamelog库
gamelog=$4
#版本号
version=$5
#############数据库备份#######################
rm -rf /usr/local/dbback/
mkdir -p /usr/local/dbback/${version}back
cd /usr/local/dbback/${version}back
echo "=======================================account start=======================================";
mysqldump account > account.sql
echo "=======================================character start=======================================";
mysqldump character > character.sql  
echo "=======================================gamelog start=======================================";
mysqldump gamelog > gamelog.sql
echo "=======================================gamedata start=======================================";
mysqldump gamedata > gamedata.sql
mysqldump gamedata server_list > server_list.sql
mysqldump gamedata lineserver > lineserver.sql
mysqldump gamedata serverid_transition > serverid_transition.sql
mysqldump gamedata config_param > config_param.sql
mysqldump gamedata across_server_config > across_server_config.sql
mysqldump gamedata across_game_server > across_game_server.sql
tar -zcvf dbback.tar.gz *.sql
echo "======================================db over=======================================";
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
cd /usr/local/zjupdatedb${version}
filepath=/usr/local/zjupdatedb${version}/db_update.zip
if [ ! -f "$filepath" ]; then 
 echo `date +%F~%H:%M`" "${gameid}"服数据库 更新失败" >> /home/update.log
 exit;
fi

echo "执行数据库升级操作"
if [ $gamedata -eq 1 ]
then
     echo "开始升级gamedata。。。"
     mysql gamedata <gamedata.sql
	 mysql gamedata < /usr/local/dbback/${version}back/server_list.sql;
	 mysql gamedata < /usr/local/dbback/${version}back/lineserver.sql;
	 mysql gamedata < /usr/local/dbback/${version}back/serverid_transition.sql;
	 mysql gamedata < /usr/local/dbback/${version}back/config_param.sql;
         mysql gamedata < /usr/local/dbback/${version}back/across_server_config.sql
         mysql gamedata < /usr/local/dbback/${version}back/across_game_server.sql
         mysql -e " update gamedata.server_list set flashver=flashver+1 ";
     elif [ $gamedata -eq 0 ]
then
     echo "不升级gamedata"
fi

if [ $character -eq 1 ]
then
     echo "开始升级character"
     mysql character < character.sql
     elif [ $character -eq 0 ]
then
     echo "不升级character"
fi

if [ $account -eq 1 ]
then
     echo "开始升级account"
     mysql account < account.sql
     elif [ $account -eq 0 ]
then
     echo "不升级account"
fi

if [ $gamelog -eq 1 ]
then
     echo "开始升级account"
     mysql gamelog < gamelog.sql
     elif [ $account -eq 0 ]
then
     echo "不升级gamelog"
fi
echo `date +%F~%H:%M`" "${gameid}"服数据库 更新成功" >> /home/update.log
