#!/bin/sh -
rm -rf /data/daxia/
mkdir /data/daxia/
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
#mysql -e 'select name,id from character.hero where character.hero.id IN (select hero_id from character.hero_longyin where character.hero_longyin.longyin_jieshu=10 and character.hero_longyin.longyin_level=8)\G;' >> /root/longyin/${gameid}longyin
#mysql -e 'select name,id from character.hero where character.hero.id IN (select hero_id from character.hero_longyin where character.hero_longyin.has_exp>5000)\G;' >> /root/longyin/${gameid}longyinexpi
 cat /home/log/logs/gameserver.log.20131008*  |grep 领取大夏龙却 > /data/daxia/$gameid-daxia.txt
 cat /home/log/logs/gameserver.log.20131009* |grep 领取大夏龙却 >> /data/daxia/$gameid-daxia.txt
