#!/bin/sh -
mysql -ss -e 'select serverid from gamedata.serverid_transition where serverid in ( select loginServerId from gamedata.server_list);' > /root/servertransid
var="0"
for transid in `cat /root/servertransid`
do
var=$var,$transid
done
echo $var
mysql -e 'delete from gamedata.serverid_transition where serverid not in ('${var}');'
~
~
