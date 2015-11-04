#!/bin/bash
for hostip in `cat /root/slist/dblist`
do
echo $hostip
scp -P36000 /root/character.sql root@"${hostip}":/tmp
done
