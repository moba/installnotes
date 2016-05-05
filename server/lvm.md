# snapshot
lvcreate -L10G -s -n rootsnapshot /dev/server1/root
mount /dev/server1/rootsnapshot /mnt/rootsnapshot
.... cp .....
umount /mnt/rootsnapshot
lvremove /dev/server1/rootsnapshot
