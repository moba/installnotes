#!/bin/bash
#
# upgrade host and all 1xx VMs
#

LOG_FILE=/root/update-$(date +%Y%m%d%H%M%S).log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

apt-get update && apt-get -y upgrade

VMS=`for f in /etc/vz/conf/1*.conf; do echo $f | awk -F'(/conf/|.conf)' {'print $2'}; done`

for vm in $VMS
do
  echo -en "========================== $vm: "
  vzctl exec2 $vm cat /etc/hostname
  vzctl enter $vm --exec "apt-get update && apt-get -y upgrade && exit"
done
~                                        
