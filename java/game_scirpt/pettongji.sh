#!/bin/sh -
mkdir /data/pet/
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
mysql -e "select name,original_sid from character.hero inner join (select distinct hero_id from character.hero_xianshiactivity where activity_id=929 and last_time between '2013-10-08 00:00:00' and '2013-10-08 02:00:00') as tm on tm.hero_id=id;" > /data/pet/$gameid-pet.txt
