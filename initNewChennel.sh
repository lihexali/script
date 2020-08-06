#!/bin/bash
# Arguments Example: 000315   hengXin    a1501f815598a9d    E948A613-6231-1134-1E71-54D31A048FE3    A8919AD0F905E49ED47644AFF1F06FD7A 40010036 00012366 

echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7

# 渠道目录
CHANNELDIR=$1
# 6位数字的完整渠道号，这里与渠道目录一致
CHANNELID=$1
# 渠道名
CHANNELNAME=$2
# Admob ID
ADMOBID=$3
# Punchbox ID
PUNCHBOXID=$4
# secret key
SECRETKEY=$5
# 电信短信代码
DIANXINID=$6
# 联通短信代码
UNICOMID=$7
# 精简版渠道号，去掉了0前缀
CHANNELID_SLIM=`echo $CHANNELID \
        | sed -E 's/(^[0-9]{6}).*/\1/' \
        | sed -E 's/[0]*([^0]+)/\1/' \
        | sed -E 's/^0.*/0/'`


vim -c %s/MC099474/$DIANXINID -c wq AndroidManifest.xml

vim -c %s/fidsms:00012243/fidsms:$UNICOMID -c wq AndroidManifest.xml

vim -c g/android:debuggable/s/true/false -c wq AndroidManifest.xml

vim -c g/999999/s//$CHANNELID -c wq ant.properties

vim -c g/_testChannel/s//_$CHANNELNAME -c wq ant.properties

vim -c g/999999/s//$CHANNELID -c wq .project

vim -c g/999999/s//$CHANNELID_SLIM -c wq ./jni/ModuleCustom_android.h

vim -c g/A8FEB248-B537.*CA3E/s//$PUNCHBOXID -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java

vim -c g/503FB59E1E.*6C65/s//$SECRETKEY -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java

vim -c g/setOutputLogEnable/s/true/false -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java

if [ -d ../$CHANNELDIR ]
then
    echo "Dir $CHANNELDIR exsit!"
else
    # 拷贝修改好的999999渠道到android目录并更名为对应渠道名
    cp -rf ../999999 ../$CHANNELDIR
    # 以下清理不必要的资源
    if [ -d ../$CHANNELDIR/assets ]; then
        rm -rf ../$CHANNELDIR/assets
    fi

    if [ -d ../$CHANNELDIR/obj ]; then
        rm -rf ../$CHANNELDIR/obj
    fi

    if [ -d ../$CHANNELDIR/res ]; then
        rm -rf ../$CHANNELDIR/res
    fi

    if [ -d ../$CHANNELDIR/bin ]; then
        rm -rf ../$CHANNELDIR/bin/*
    fi

    if [ -d ../$CHANNELDIR/lib ]; then
        rm -rf ../$CHANNELDIR/lib
    fi

    if [ -f ../$CHANNELDIR/initNewChennel.sh ]; then
        rm ../$CHANNELDIR/initNewChennel.sh
    fi

    if [ -f ../$CHANNELDIR/noDianXinInitNewChennel.sh ]; then
        rm ../$CHANNELDIR/noDianXinInitNewChennel.sh
    fi
fi

# 利用git将999999渠道工程还原
# git reset --hard HEAD
