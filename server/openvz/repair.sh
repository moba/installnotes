#!/bin/baxh

#
# repair and restart all openvz containers
# 

VMS=`for f in /etc/vz/conf/*.conf; do echo $f | awk -F'(/conf/|.conf)' {'print $2'}; done`

for vm in $VMS
do
  echo -en "========================== $vm: "
  vzquota off $vm
  vzquota on $vm
  vzctl start $vm & 
done
