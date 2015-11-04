#!/bin/sh -
limit=`lsof -n |awk '/IP/{print $2}'|sort|uniq -c |sort -nr|more | awk 'NR==1 {print $1}'`
if [ $limit -ge 1024 ];then
service ssh2 restart
echo the ssh2 restart done at `date +%Y-%m-%d-%T` >> /data/limitstat
else
echo the limit is ok >> /data/limitok
fi

