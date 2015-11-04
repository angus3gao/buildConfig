#!/bin/bash
mysql gamedata < /usr/local/zjupdatedbv9/gamedata.sql
echo `date +%F~%H:%M`" dddddd服数据库 更新成功" >> /home/update.log