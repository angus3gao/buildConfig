#!/bin/bash 
##脚本用于域名绑定，对应domainlist列表

list=domainlist
cat $list|while read hostname
do
name=$(echo $hostname|awk '{print $2;}')
sid=$(echo $hostname|awk '{print $1;}')
echo "$name"
echo "$sid"
qc-domain-bind --domain=s"${sid}".app100625638.qqopenapp.com --ips="${name}" --ports=80 --endpoint=gz-api.tencentyun.com
qc-domain-bind --domain=s"${sid}".app100625638.qqopenapp.com --ips="${name}" --ports=443 --endpoint=gz-api.tencentyun.com
done
