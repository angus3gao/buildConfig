#!/bin/bash
#游戏服务器id
serverid=$1
#数据库服务器ip
dbserverIp=$2
flag='&amp'
#平台id 固定
deptid=1005
cd /tmp/;
tar -zxvf jhserver.tar.gz
rm -rf /usr/local/jhserver
mv jhserver /usr/local/
echo "=======================================清除pagepage缓存编译文件=======================================";
rm -rf /usr/local/jhserver/gameserver/work/Catalina/localhost;
sed -i "/server.sid=/ {s/.*/server.sid=${serverid}/}" /usr/local/jhserver/gameserver/conf/serverparam.properties
sed -i "/server.dept=/ {s/.*/server.dept=${deptid}/}" /usr/local/jhserver/gameserver/conf/serverparam.properties
sed -i "/server.isInteriorhttplog=/ {s/.*/server.isInteriorhttplog=true/}" /usr/local/jhserver/gameserver/conf/serverparam.properties
rm -rf /usr/local/jhserver/gameserver/conf/context.xml
echo "<Context>
	<Resource name=\"jdbc/account\" auth=\"Container\" type=\"javax.sql.DataSource\"
               maxActive=\"100\" maxIdle=\"50\" maxWait=\"1000\" validationQuery=\"select 1\"
               username=\"developer\" password=\"helloworld\" driverClassName=\"com.mysql.jdbc.Driver\"
               removeAbandoned=\"true\" removeAbandonedTimeout=\"60\"
               url=\"jdbc:mysql://${dbserverIp}/account?autoReconnect=true${flag};useUnicode=true${flag};characterEncoding=utf8\"/>
  	<Resource name=\"jdbc/character\" auth=\"Container\" type=\"javax.sql.DataSource\"
               maxActive=\"100\" maxIdle=\"50\" maxWait=\"1000\" validationQuery=\"select 1\"
                username=\"developer\" password=\"helloworld\" driverClassName=\"com.mysql.jdbc.Driver\"
               removeAbandoned=\"true\" removeAbandonedTimeout=\"60\"
               url=\"jdbc:mysql://${dbserverIp}/character?autoReconnect=true${flag};useUnicode=true${flag};characterEncoding=utf8\"/>
   	<Resource name=\"jdbc/gamedata\" auth=\"Container\" type=\"javax.sql.DataSource\"
               maxActive=\"30\" maxIdle=\"10\" maxWait=\"1000\" validationQuery=\"select 1\"
                username=\"developer\" password=\"helloworld\" driverClassName=\"com.mysql.jdbc.Driver\"
               removeAbandoned=\"true\" removeAbandonedTimeout=\"60\"
               url=\"jdbc:mysql://${dbserverIp}/gamedata?autoReconnect=true${flag};useUnicode=true${flag};characterEncoding=utf8\"/>
    <Resource name=\"jdbc/gamelog\" auth=\"Container\" type=\"javax.sql.DataSource\"
               maxActive=\"30\" maxIdle=\"10\" maxWait=\"1000\" validationQuery=\"select 1\"
               username=\"developer\" password=\"helloworld\" driverClassName=\"com.mysql.jdbc.Driver\"
               removeAbandoned=\"true\" removeAbandonedTimeout=\"60\"
               url=\"jdbc:mysql://${dbserverIp}/gamelog?autoReconnect=true${flag};useUnicode=true${flag};characterEncoding=utf8\"/>
    <WatchedResource>WEB-INF/web.xml</WatchedResource>
</Context>
" > /usr/local/jhserver/gameserver/conf/context.xml
echo "=======================================服务器安装完成=======================================";

