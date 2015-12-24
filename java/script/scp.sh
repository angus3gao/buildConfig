#!/bin/bash
for hostip in `cat ./list`
do
echo $hostip
scp -P22 /root/character.sql root@"${hostip}":/tmp
done
