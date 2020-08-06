#!/bin/sh
# 删除writepath下面的文件和数据库

delfiles(){
    tdir=$1
    wp="/data/data/com.LightYear.UnderWorld"
    adb shell "run-as com.LightYear.UnderWorld rm -r /data/data/com.LightYear.UnderWorld/$tdir"
 }

 delfiles 'files/src'
 delfiles 'files/res'
 delfiles 'databases'
