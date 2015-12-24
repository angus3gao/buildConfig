#!/bin/bash
echo "SQL全服查询或更新(该脚本在管理后台所在的服务器执行)"

echo "请输入服务器列表"
read list
echo "请输入要执行的SQL statements"
read sqlpath
#echo "请输入要执行的密码"
#read passwd

echo "这是你的键入参数: $list $sqlpath . 确认继续请输入'Y',退出脚本请输入'N'" 
read enter
enter=$(echo $enter | tr '[A-Z]' '[a-z]')
if [[ ! "$enter" == 'y'  ]];then
echo "Nothing to do!"
exit 0
fi


for hostname in `cat $list`
do sleep 1
{
echo $hostname
ssh -p22 root@"${hostname}" "mysql -uroot  -e \"${sqlpath}\""
}&
done
wait
exit 0
