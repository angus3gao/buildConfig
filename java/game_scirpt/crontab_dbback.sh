#!/bin/bash
rm -fr /tmp/updategame.log /tmp/out.txt
echo "jiaobne  ceshi  " > /tmp/out2.txt
/root/gamescript/list.sh ALL
echo "jioabne ceshi 2" >> /tmp/out2.txt
/root/gamescript/serverupdate_fordbback.sh '/root/slist/dblist' '/bin/sh /root/gamescript/dbbak.sh'
echo "jiaoben ceshi 3" >> /tmp/out3.txt
rm -rf /root/slist/*
