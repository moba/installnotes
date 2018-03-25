#!/bin/bash

REMOVE_APPS="Drive Duo Gmail2 Music2 Videos XperiaTransferMobile-release com.amazon.mShop.android.shopping com.amazon.kindle com.facebook.appmanager com.facebook.katana com.s.antivirus com.sonymobile.xperialounge.services com.spotify.music" 

BACKUPDIR="/sdcard/Backups/SystemApps"
SYSTEMDIR="/system/app"

ADB_COMMAND=$(cat << END
su
mkdir -p /sdcard/Backups/SystemApps
mount -o rw,remount /system
END
)

for app in $REMOVE_APPS
do
    ADB_COMMAND+="\nmv $SYSTEMDIR/$app $BACKUPDIR"
done

ADB_COMMAND+="\nmount -o ro,remount /system\nexit\nexit"

echo "**************************************"
echo "This runs the following with adb shell"
echo "**************************************"
echo ""
echo -e "$ADB_COMMAND"
echo ""
echo "**************************************"

read -p "Are you sure? " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from  shell or function but don't exit interactive shell
fi

echo -e "$ADB_COMMAND" | adb shell
