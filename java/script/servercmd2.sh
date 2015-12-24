#########################################################################
# File Name: servercmd.sh
# Author: gaosi
# mail: gaosi_angus@163.com
# Created Time: 2014年03月07日 星期五 23时10分34秒
#########################################################################
#!/bin/bash
##远程服务器执行脚本（仅执行命令，不包含上传）
list=$1
command=$2

for hostname in `cat $list`
do sleep 1
{
	echo $hostname
	ssh -p36000 root@"${hostname}" "${command}"
}&
done
wait
exit 0
