#!/bin/sh
# 获得UW游戏在android平台的writeable path 下的文件
# 使用方法：chmod +x adbpull.sh && ./adbpull.sh
# 拷到的文件将放在与脚本同目录下的uw_android_files文件夹下

uwdir="uw_android_files"
getfiles(){
    tdir=$1
    wp="/data/data/com.LightYear.UnderWorld"
    tmplist="uw_fileList.txt"
    adb shell "run-as com.LightYear.UnderWorld ls '$wp/$tdir' >> '/sdcard/${tmplist}' "
    adb pull "/sdcard/${tmplist}" $uwdir/$tmplist
    adb shell "rm '/sdcard/${tmplist}'"

    mkdir -p $uwdir/$tdir
    for f in `cat $uwdir/$tmplist`
    do
        adb shell "run-as com.LightYear.UnderWorld cat '$wp/$tdir/$f' > '/sdcard/$f' "
        echo 'cp '/sdcard/$f' --> '$uwdir/$tdir
        adb pull /sdcard/$f $uwdir/$tdir
        adb shell "rm '/sdcard/$f'"
    done
}

if [  -d "$uwdir" ]; then  
    rm -rf "$uwdir"  
fi  
mkdir "$uwdir"

getfiles 'files/src'
getfiles 'files/res'
getfiles 'databases'

