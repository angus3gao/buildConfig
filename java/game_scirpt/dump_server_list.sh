#!/bin/bash
flag=$1
serverids=$2
rm -rf /data/log/slist/*
#  ������Ҫ��ÿ��ָ��֮���пո� ��["flag ����ִ���
if [ "$flag" == "NOTIN" ]; then
#�˴� -e ��������� -ss ��ʹ�õ�½ssh���û��������½���ݿ�
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist where serverId not in ($serverids)" > /data/slist/gameiplist
 echo "��"$serverids"�������� ������Ϸ�б�Ip�������"
 cat /data/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbIp from serverlist.serverlist where serverId not in ($serverids)" > /data/slist/dblist
 echo "��"$serverids"�������� �������ݿ��б�Ip�������"
 cat /data/slist/dblist
 exit;
fi
if [ "$flag" == "IN" ]; then 
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist where serverId in ($serverids)" > /data/slist/gameiplist
 echo "����"$serverids"��Ϸ�б�Ip�������"
 cat /data/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbIp from serverlist.serverlist where serverId in ($serverids)" > /data/slist/dblist
 echo "����"$serverids"���ݿ��б�Ip�������"
 cat /data/slist/dblist
 exit;
fi
if [ "$flag" == "ALL" ]; then 
 mysql -uroot -pgaosi -e "select gameIp from serverlist.serverlist"> /root/slist/gameiplist
 echo "�������� ��Ϸ�б�Ip���"
 cat /root/slist/gameiplist
 mysql -uroot -pgaosi -e "select dbip from serverlist.serverlist" > /root/slist/dblist
 echo "�������� ���ݿ��б�IP���"
 cat /root/slist/dblist
 exit;
fi 
echo "�������� ��ȷ��������"
echo "���(����ĳ̨)������ȫ������ ./list NOTIN ������id��,�ָ�"
echo "���(ֻ����) ĳ��̨�������� ./list IN ������id,�ָ�"
echo "���(ȫ��) ���� �� ./list ALL"