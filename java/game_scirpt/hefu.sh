合服脚本的学习
#!/bin/bash
sourceip=$1
sourceus=$2
sourceps=$3
targetip=$4
targetus=$5
targetps=$6

#echo "将IP $targetip 导入$sourceip 确定继续请输入'Y',退出脚本请输入'N'"
#read enter
#enter=$(echo $enter | tr '[A-Z]' '[a-z]')
#if [[ ! "$enter" == 'y' ]]; then
#	echo "脚本终止！"
#	exit 0
#fi 

#备份数据这是必须的
echo "--开始备份导入数据源"
mysqldump -h$sourceip -u$sourceus -p$sourceps --skip-lock-tables account>/data/hefu/bak/a_account.sql
echo "导出数据库源account库备份完毕"
mysqldump -h$sourceip -u$sourceus -p$sourceps --skip-lock-tables character>/data/hefu/bak/a_character.sql
echo "导出数据库源character库备份完毕"
mysqldump -h$sourceip -u$sourceus -p$sourceps --skip-lock-tables gamelog>/data/hefu/bak/a_gamelog.sql     // --ship-lock-tables 锁表操作 ， 防止合服过程中有数据改动， 理论上是没有的
echo "导出数据库源account库备份完毕"
echo "开始备份导出数据源"
mysqldump -h$targetip -u$targetus -p$targetps --skip-lock-tables account>/data/hefu/bak/b_account.sql
echo "导出数据库源account库备份完毕"
mysqldump -h$targetip -u$targetus -p$targetps --skip-lock-tables character>/data/hefu/bak/b_character.sql
echo "导出数据库源character库备份完毕"
mysqldump -h$targetip -u$targetus -p$targetps --skip-lock-tables gamelog>/data/hefu/bak/b_gamelog.sql
echo "导出数据库源character库备份完毕"

#java -cp "包的引入":" 是否包含依赖关系还需要验证！linux下的 java执行 还有各个参数需要去了解！"
param="-cp "hf.jar:mysql-connector-java-5.1.8-bin.jar" -Xms102 4m -Xmx2048m -Xmn512m -XX:SurvivorRatio=1 -XX:PermSize=10m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC 
 -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=0 -XX:+CMSClassUnloadingEnabled -XX:-CMSParallelRemarkEnabled -XX:CMSInitiatingOccupancyFraction=70
    -XX:SoftRefLRUPolicyMSPerMB=0 hefu.ConnectionDB 1 "$sourceip" "$sourceus" "$sourceps" "$targetip" "$targetus" "$targetps      //参数设置

java $param

echo " 是否要将生成的数据导入$sourceip 确认继续请输入 'Y',退出脚本请输入'N'"
read enter
enter=$(echo $enter | tr '[A-Z]' '[a-z]')
if [[ ! "$enter" == 'y' ]]; then
 echo "脚本终止！"
 exit 0
fi 

echo "正服导入数据"

dir="/data/hefu/datas/"
for file in ` ls $dir `
do 
 if [ -d $dir"/"$file ]; then
  echo ""
 else 
  echo "正在执行"$dir"/"$file
  mysql -h$sourceip -u$sourceus -p$sourceps < $dir"/"$file
 fi
done

echo "执行完毕"

sh hf1.sh "192.168.150.1" "aj2" "aj2" "127.0.0.1" "root" "gaosi"
