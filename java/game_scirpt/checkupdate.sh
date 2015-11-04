#!/bin/bash
rm -fr /tmp/updategame.log /tmp/updatedb.log
/root/gamescript/list.sh ALL
for i in `cat /root/slist/gameiplist`;do ssh -p36000 $i "cat /home/update.log" >> /tmp/updategame.log; done
for i in `cat /root/slist/dblist`;do ssh -p36000 $i "cat /home/update.log" >> /tmp/updatedb.log; done
rm -rf /root/slist/*
