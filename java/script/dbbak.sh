#!/bin/sh -
###gameserver data backup script###
mkdir -p /data/DBbackup
mkdir -p /data/data_copy
mkdir -p /data/backuplog
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
gamedata='gamedata'
character='character'
account='account'
log='gamelog'
datapath='/data/DBbackup'
mysqldump  --lock-tables=false $gamedata|gzip > $datapath/${gameid}-${gamedata}-`date +%F-%H%M`.gz
mysqldump  --lock-tables=false $character|gzip > $datapath/${gameid}-${character}-`date +%F-%H%M`.gz
mysqldump  --lock-tables=false $account|gzip > $datapath/${gameid}-${account}-`date +%F-%H%M`.gz
mysqldump  --lock-tables=false $log|gzip > $datapath/${gameid}-${log}-`date +%F-%H%M`.gz
cp $datapath/* /data/data_copy
echo DB in `date +%F-%T` done >> /data/backuplog/bk_log
##delete the oldest backup 2 days ago
##find -mtime +2 查的是2*24小时以前的文件
find /data/data_copy  -name "*.gz" -mtime +2 |xargs rm -fr
find /data/DBbackup/  -name "*.gz" -mtime +2 |xargs rm -fr
