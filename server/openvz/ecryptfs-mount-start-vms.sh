#!/bin/sh
#
# mount ecryptfs partition and start containers
# -- better use LUKS!
#

ECRYPTSRC="/vm/.encrypted"
MOUNTPOINT="/vm/encrypted"
FNEG_SIG=TODO                  # put fneg_sig here

mount -t ecryptfs -o ecryptfs_cipher=aes -o ecryptfs_key_bytes=32 -o ecryptfs_unlink_sigs -o ecryptfs_passthrough=no -o ecryptfs_enable_filename_crypto=y -o ecryptfs_fnek_sig=$FNEK_SIG $ECRYPTSRC $MOUNTPOINT 

VMS=`ls $MOUNTPOINT/private/`

for vm in $VMS
do
  vzctl start $vm
done
