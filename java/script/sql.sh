#!/bin/sh -
serverid=`cat /usr/local/jhserver/gameserver/conf/serverparam.properties|sed -n '2p'|awk -F'=' '{print $2}'`
mysql -e 'select count(*) from character.hero_goods where f_goodmodel_id = 20278;' > ${serverid}fu

