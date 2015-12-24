#########################################################################
# File Name: db_after.sh
# Author: gaosi
# mail: gaosi_angus@163.com
# Created Time: 2014年03月09日 星期日 00时27分49秒
#########################################################################
#!/bin/bash
#是否升级gamedata
gamedata=$1
#是否升级character
character=$2
#是否升级account
account=$3
#是否升级gamelog
gamelog=$4
#版本号
version=$5
###########################备份数据库#########################
rm -rf /data/game/dbback/
mkdir -p /data/game/dbback/${version}back
cd /data/game/dbback/${version}back
echo "=============================account start=======================================";
mysqldump account > account.sql
echo "==============================character start=======================================";
mysqldump character > character.sql
echo "==============================gamelog start=======================================";
mysqldump gamelog > gamelog.sql
mysqldump gamedata server_list > server_list.sql
mysqldump gamedata lineserver > lineserver.sql
mysqldump gamedata serverid_transition > serverid_transition.sql
mysqldump gamedata config_param > config_param.sql
mysqldump gamedata across_game_server > across_game_server.sql
tar -zcvf dbback.tar.gz *.sql
echo "============================db over==========================================";
gameid=$(mysql -ss -e "select loginServerId from gamedata.server_list order by loginServerId")
cd /data/udata/data${version}
filepath=/data/udata/data${version}/db_update.zip
if [ ! -f "$filepath" ];then
 echo `date +%F~%H:%M`" "${gameid}"服数据库 更新失败" >> /data/ugame/update.log
 exit;
fi
echo "执行数据库升级操作"
 mysql gamedata < gamedata.sql
 mysql gamedata < /data/game/dbback/${version}back/server_list.sql
 mysql gamedata < /data/game/dbback/${version}back/lineserver.sql
 mysql gamedata < /data/game/dbback/${version}back/server_transition.sql
 mysql gamedata < /data/game/dbback/${version}back/config_param.sql
 mysql gamedata < /data/game/dbback/${version}back/accross_server_config.sql
 mysql gamedata < /data/game/dbback/${version}back/accross_game_server.sql
 mysql -e "update gamedata.server_list set flashver=flashver+1";
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
 echo "开始升级account"
 mysql account < account.sql
elif [ $account -eq 0 ]
then
 echo "不升级account"
fi



if [ $gamelog -eq 1 ]
 echo "开始升级gamelog"
 mysql gamelog < gamelog.sql
elif [ $gamelog -eq 0 ]
then
 echo "不升级gamelog"
fi
echo `date +%F~%H:%M`" "${gameid}"服数据库 更新成功" >> /home/update.log