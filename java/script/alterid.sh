#!/bin/bash
for tablename in `cat /root/gamescript/tables`
do
echo $tablename
mysql -e 'alter table character.'${tablename}' auto_increment=1;'
done
for acname in `cat /root/gamescript/accounttable`
do 
echo $acname
mysql -e 'alter table account.'${acname}' auto_increment=1;'
done
