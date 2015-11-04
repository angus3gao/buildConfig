#!/bin/bash
##全服务器执行脚本(仅执行命令,不包含上传)
echo "请输入服务器列表"
read list
echo "请输入需要拷贝文件的绝对路径"
read spath
echo "请输入文件的目标路径"
read dpath
echo "这是你的键入参数: scp -P36000 -r "${spath}" root@"${list}" "${dpath}" 确认继续请输入'yes',退出脚本请输入'no'" 
read enter
if [ $enter == 'yes' ]
then
        echo "脚本将依次执行"
else
        echo "Nothing to do"
        exit 0
fi
for hostname in `cat $list`
do sleep 1
{
echo $hostname
scp -P36000 -r "${spath}"  root@"${hostname}":"$dpath"
}&
done
wait
exit 0
