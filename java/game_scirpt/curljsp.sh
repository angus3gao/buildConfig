#!/bin/sh -
for servername in `cat /root/slist/gameiplist`
do
    echo $servername
ssh -p36000 -l root ${servername} curl http://127.0.0.1/gameserverweb/gm/100039.jsp
done
