echo "开始强制关闭游戏服务器"
kill -9 `ps aux |grep -i gameserver |grep -v grep |awk '{print $2}'`
