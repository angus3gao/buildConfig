#!/bin/bash
##用于执行完命令将打印结果输出到time.txt里方便查看

##全服务器执行脚本(仅执行命令,不包含上传)
echo "请输入服务器列表"
read list
echo "请输入要执行的命令"
read command
echo "这是你的键入参数: ssh -p22 root@"${list}" "${command}" 确认继续请输入'yes',退出脚本请输入'no'" 
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
ssh -p22 root@"${hostname}" "${command}" >> ./time.txt
}&
done
wait
exit 0
