#!/bin/bash - 

MYDATE=`date +%H%M%S_%d%m%y`

echo "Processing org.cocos2dx.FishingJoy2 monkey-test."
echo "Write log in ~/monkey.$MYDATE.log"

adb shell monkey -s 41341596 -p org.cocos2dx.FishingJoy2 --monitor-native-crashes --ignore-security-exceptions --kill-process-after-error --pct-trackball 0 --pct-nav 10 --pct-anyevent 10 -v -v --throttle 500 40000 > ~/monkey.$MYDATE.log

echo "Monkey test stopped!"
NOWDATE=`date +%H%M%S_%d%m%y`
echo $NOWDATE
