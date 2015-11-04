#!/bin/bash
serverid=$(mysql -ss -e"select loginServerId from gamedata.server_list order by loginServerId")
mysql -e "delete from gamedata.lineserver";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',1,'醉剑一线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',2,'醉剑二线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',3,'醉剑三线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',4,'醉剑四线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',5,'醉剑五线',1);";
mysql -e "INSERT INTO gamedata.lineserver VALUES ('${serverid}',6,'醉剑六线',1);";
mysql -e "update gamedata.dbcachelist set version=version+1 where  cachename='linelist';"
