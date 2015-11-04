#!/bin/bash -
##全服务器执行脚本(仅执行命令,不包含上传)---heaton by 2011-11-13(modification time)##
list=$1
command=$2
#exec 3>&1 ;list=$(dialog --title "[Getting server list]" --backtitle "http://www.tianshenhudong.com/" --inputbox "Please input a location path of server list" 10 60 2>&1 1>&3);exec 3>&-
#exec 3>&1 ;command=$(dialog --title "[The create of command]" --backtitle "http://www.tianshenhudong.com/" --inputbox "Input command to be processed" 10 150 2>&1 1>&3);exec 3>&-
echo -n "这是你的键入参数: ssh ${list} ${command} 是否继续运行脚本（Y/N）:"
read enter
enter=$(echo $enter | tr '[A-Z]' '[a-z]')
if [[ ! "$enter" == 'y'  ]];then
echo "当前脚本被你活生生的终止退出!"
exit 0
fi
var1=$(echo "$list" | awk 'BEGIN{FS=","} {print $1}')
var2=$(echo "$list" | awk 'BEGIN{FS=","} {print $2}')
var3=$(echo "$list" | awk 'BEGIN{FS=","} {print $3}')
var4=$(echo "$list" | awk 'BEGIN{FS=","} {print $4}')
var5=$(echo "$list" | awk 'BEGIN{FS=","} {print $5}')
cat "$var1" 2>/dev/null| grep -v "^#" | grep -v "^$" >/tmp/a.tmp
cat "$var2" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var3" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var4" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
cat "$var5" 2>/dev/null| grep -v "^#" | grep -v "^$" >>/tmp/a.tmp
num=`nl /tmp/a.tmp|awk '{print $1}'|sed -n '$p'`  
echo "当前将对${num}台游戏服务器进行操作"
for hostname in `cat /tmp/a.tmp`
do sleep 1
{
echo "对IP=${hostname}的服务器操作"
 ssh -p36000 ${hostname} "${command}"
}&
done
wait
exit 0
