#!/bin/sh -
rm -rf /data/all2
gameid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
#for servername in `cat /root/slist/dblist`
#for servername in `cat /root/slist/gameiplist`
for servername in `cat /root/slist/gameiplist`
do
#ssh -p36000 -l root ${servername} "cat /data/all && echo " >> /data/all2
#ssh -p36000 -l root ${servername} "cat /data/jsp.txt && echo " >> /data/jspall
  scp -P36000 ${servername}:/data/daxia/* /data/dxlq/
done
