#!/bin/sh -
#!/bin/bash
for all in `cat /root/slist/gameiplist`
do
ssh -p36000 ${all} "cat /root/alljsp && echo " >> /data/allofjsp
done
