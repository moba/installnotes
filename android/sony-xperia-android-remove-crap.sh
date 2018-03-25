#!/bin/sh
set -x

# adb shell pm list packages -d
# adb shell pm list packages

adb shell pm uninstall -k --user 0 com.sonymobile.entrance
adb shell pm uninstall -k --user 0 com.sonymobile.xperiatransfermobile
adb shell pm uninstall -k --user 0 com.sonymobile.phoneusage
adb shell pm uninstall -k --user 0 com.sonymobile.googleanalyticsproxy
adb shell pm uninstall -k --user 0 com.sonymobile.assist.persistent
adb shell pm uninstall -k --user 0 com.sonymobile.xperiaweather
adb shell pm uninstall -k --user 0 com.sonymobile.xperialounge.services

adb shell pm uninstall -k --user 0 com.sonymobile.music.googlelyricsplugin        
adb shell pm uninstall -k --user 0 com.sonymobile.music.wikipediaplugin        
adb shell pm uninstall -k --user 0 com.sonymobile.music.youtubeplugin
adb shell pm uninstall -k --user 0 com.sonymobile.music.youtubekaraokeplugin

adb shell pm uninstall -k --user 0 com.spotify.music
adb shell pm uninstall -k --user 0 com.amazon.kindle
adb shell pm uninstall -k --user 0 com.s.antivirus
adb shell pm uninstall -k --user 0 com.amazon.mShop.android.shopping
adb shell pm uninstall -k --user 0 com.facebook.katana

# maybe keep the following? experimental

adb shell pm uninstall -k --user 0 com.sonyericsson.music
adb shell pm uninstall -k --user 0 com.sonymobile.prediction       
adb shell pm uninstall -k --user 0 com.sonymobile.anondata
adb shell pm uninstall -k --user 0 com.sonymobile.retaildemo
adb shell pm uninstall -k --user 0 com.sonymobile.assist  
adb shell pm uninstall -k --user 0 com.sonymobile.support

# google apps you might want to keep

adb shell pm uninstall -k --user 0 com.google.android.apps.docs.editors.sheets                              ⏎
adb shell pm uninstall -k --user 0 com.google.android.apps.docs.editors.slides

