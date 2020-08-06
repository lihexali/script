#!/bin/bash
# 检查渠道文件夹下，几个关键文件里渠道号是否一致
# 一致：返回0
# 不一致：返回1
# USAGE: checkChannelInfo.sh <channel_dir>
# EXAMPLE: ./checkChannelInfo.sh 999999

CHANNEL_DIR=$1
CHANNEL_ID=`echo $CHANNEL_DIR \
        | sed -r 's/.*([0-9]{6}).*/\1/' \
        | sed -r 's/[0]*([^0]+)/\1/' \
        | sed -r 's/^0.*/0/'`
echo 'CHANNEL_ID: '$CHANNEL_ID
MANIFEST_FILE=$CHANNEL_DIR'/AndroidManifest.xml'
if [ -e $MANIFEST_FILE ]; then
    echo
    echo 'Parsing '$MANIFEST_FILE
    echo "--------------------------"

    VERSION_CODE=`grep  android:versionCode $MANIFEST_FILE \
                  | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    VERSION_NAME=`grep  android:versionName $MANIFEST_FILE \
                  | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    DEBUGABLE=`grep android:debuggable $MANIFEST_FILE \
                  | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    echo 'Android Version Code: '$VERSION_CODE
    echo 'Android Version Name: '$VERSION_NAME
    echo 'Android Debuggable: '$DEBUGABLE
    echo 'DianXin Code: '
    grep meta.*feeCode $MANIFEST_FILE \
                  | sed -r 's/.*value=".{36}(.{8}).*".*/    \1/g'
else
    echo 'File '$MANIFEST_FILE' is not exsit!'
fi

ANT_PROPERTIES_FILE=$CHANNEL_DIR'/ant.properties'
CHID_IN_ANT_FILE=
if [ -e $ANT_PROPERTIES_FILE ]; then
    echo
    echo 'Parsing '$ANT_PROPERTIES_FILE
    echo "--------------------------"

    echo `grep ^apk.channel.id   $ANT_PROPERTIES_FILE`
    echo `grep ^apk.channel.name $ANT_PROPERTIES_FILE`
    CHID_IN_ANT_FILE=`grep ^apk.channel.id $ANT_PROPERTIES_FILE \
                 | sed -r 's/.*([0-9]{6})/\1/' \
            	 | sed -r 's/[0]*([^0]+)/\1/' \
           	 | sed -r 's/^0.*/0/'`
    echo 'CHID_IN_ANT_FILE: '$CHID_IN_ANT_FILE
else
    echo 'File '$ANT_PROPERTIES_FILE' is not exsit!'
fi

PROJECT_FILE=$CHANNEL_DIR'/.project'
CHID_IN_PROJ_FILE=
if [ -e $PROJECT_FILE ]; then
    echo
    echo 'Parsing '$PROJECT_FILE
    echo "--------------------------"

    PROJECT_NAME=`grep name\>Fi.*  $PROJECT_FILE \
        | sed -r 's/\s//g' \
        | sed -r 's/[^>]+>(.*)<.*/\1/'`
    echo 'PROJECT_NAME: '$PROJECT_NAME
    CHID_IN_PROJ_FILE=`echo $PROJECT_NAME \
        | sed -r 's/.*_([0-9]{6}).*/\1/' \
        | sed -r 's/[0]*([^0]+)/\1/' \
        | sed -r 's/^0.*/0/'`
    echo 'CHID_IN_PROJ_FILE: '$CHID_IN_PROJ_FILE
else
    echo 'File '$PROJECT_FILE' is not exsit!'
fi

JAVA_FILE=$CHANNEL_DIR'/src/org/cocos2dx/FishingJoy2/FishingJoy2.java'
if [ -e $JAVA_FILE ]; then
    echo
    echo 'Parsing '$JAVA_FILE
    echo "--------------------------"

    ADMOB_ID=`grep "priv.* strAdMobID"  $JAVA_FILE \
      | sed -r 's/\s//g' \
      | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    echo 'Admob ID: '$ADMOB_ID

    PUNCHBOX_ID=`grep "priv.* strPunchBoxID"  $JAVA_FILE \
      | sed -r 's/\s//g' \
      | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    echo 'PunchBox ID: '$PUNCHBOX_ID

    SECRETKEY=`grep "priv.* strSecretKey"  $JAVA_FILE \
      | sed -r 's/\s//g' \
      | sed -r 's/.[^"]+"([^"]+)".*/\1/'`
    echo 'SecretKey: '$SECRETKEY

    echo `grep "Wrapper.*LogEnable"  $JAVA_FILE \
        | sed -r 's/\s//g'`
else
    echo 'File '$JAVA_FILE' is not exsit!'
fi

MODULE_FILE=$CHANNEL_DIR'/jni/ModuleCustom_android.h'
CHID_IN_MODULE_FILE=
if [ -e $MODULE_FILE ]; then
    echo
    echo 'Parsing '$MODULE_FILE
    echo "--------------------------"

     CHID_IN_MODULE_FILE=`grep "#def.*CHANNAL_ID" $MODULE_FILE \
         | sed -r 's/[^[:digit:]]+//g'`
    # echo 'CHID_IN_MODULE_FILE: '$CHID_IN_MODULE_FILE
    cat $MODULE_FILE | iconv -c -f gbk -t gbk

else
    echo 'File '$MODULE_FILE' is not exsit!'
fi

BUILD_NATIVE_FILE=$CHANNEL_DIR'/build_native.sh'
if [ -e $BUILD_NATIVE_FILE ]; then
    echo
    echo 'Parsing '$BUILD_NATIVE_FILE
    echo "--------------------------"
    grep "\$GAME_AN.*copyResByResolution.*" $BUILD_NATIVE_FILE
else
    echo 'File '$BUILD_NATIVE_FILE' is not exsit!'
fi

# Genrate report
echo
echo "================================================="
echo "                Report                           "
echo "================================================="

    # Check all Channel id are the same
    if [[ "$CHANNEL_ID" = "$CHID_IN_ANT_FILE" && \
        "$CHID_IN_ANT_FILE" = "$CHID_IN_PROJ_FILE" && \
        "$CHID_IN_PROJ_FILE" = "$CHID_IN_MODULE_FILE" \
        ]]; then
        echo "CHANNEL_ID OK!"

    else
        echo "CHANNEL_ID is not the same!"
        echo 'CHANNEL ID: '$CHANNEL_ID
        echo 'CHID_IN_ANT_FILE: '$CHID_IN_ANT_FILE
        echo 'CHID_IN_PROJ_FILE: '$CHID_IN_PROJ_FILE
        echo 'CHID_IN_MODULE_FILE: '$CHID_IN_MODULE_FILE

    fi

