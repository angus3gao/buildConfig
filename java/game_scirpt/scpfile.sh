#!/bin/bash
##全服SCP文件覆盖脚本
serverlist=$1
filepath=$2
clientpath=$3
echo "脚本将要执行的动作：scp -r ${filepath} ${serverlist}:${clientpath}。确认继续请输入'Y',退出脚本请输入'N'" 
read enter
enter=$(echo $enter | tr '[A-Z]' '[a-z]')
if [[ ! "$enter" == 'y'  ]];then
echo "脚本终止!"
exit 0
fi
var1=$(echo "$serverlist" | awk 'BEGIN{FS=","} {print $1}')
var2=$(echo "$serverlist" | awk 'BEGIN{FS=","} {print $2}')
var3=$(echo "$serverlist" | awk 'BEGIN{FS=","} {print $3}')
var4=$(echo "$serverlist" | awk 'BEGIN{FS=","} {print $4}')
var5=$(echo "$serverlist" | awk 'BEGIN{FS=","} {print $5}')
cat "$var1" 2>/dev/null| grep -v "^#" | grep -v "^$" >/tmp/a.tmp
cat "$var2" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var3" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var4" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var5" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
num=`nl /tmp/a.tmp|awk '{print $1}'|sed -n '$p'`
echo "线程数为${num},将对${num}台服务器进行操作"

for hostname in `cat /tmp/a.tmp`
do sleep 1
{
echo "对IP=${hostname}的服务器操作"
scp -P36000 -r ${filepath} root@${hostname}:${clientpath}
}&
done
wait
exit 0
