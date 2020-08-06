#!/bin/bash
# arg example: 000315   hengXin    a1501f815598a9d    E948A613-6231-1134-1E71-54D31A048FE3    A8919AD0F905E49ED47644AFF1F06FD7A    40010036  

echo $1
echo $2
echo $3
echo $4
echo $5
#echo $6

#vim -c %s/MC099474/$6 -c wq AndroidManifest.xml
vim -c g/android:debuggable/s/true/false -c wq AndroidManifest.xml

vim -c g/999999/s//$1 -c wq ant.properties
vim -c g/_testChannel/s//_$2 -c wq ant.properties

vim -c g/999999/s//$1 -c wq .project

vim -c g/999999/s//$1 -c wq ./jni/ModuleCustom_android.h

vim -c g/a1507f7080c3fe7/s//$3 -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java
vim -c g/A8FEB248B537.*A3E/s//$5 -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java
vim -c g/0815695621.*A180/s//$5 -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java

vim -c g/setOutputLogEnable/s/true/false -c wq ./src/org/cocos2dx/FishingJoy2/FishingJoy2.java

if [ -d ../$1 ]
then
    echo "Dir $1 exsit!"
else
    cp -rf ../999999 ../$1
    if [ -d ../$1/assets ]; then
        rm -rf ../$1/assets
    fi

    if [ -d ../$1/obj ]; then
        rm -rf ../$1/obj
    fi

    if [ -d ../$1/res ]; then
        rm -rf ../$1/res
    fi

    if [ -d ../$1/bin ]; then
        rm -rf ../$1/bin/*
    fi

    if [ -d ../$1/lib ]; then
        rm -rf ../$1/lib
    fi

    if [ -f ../$1/initNewChennel.sh ]; then
        rm ../$1/initNewChennel.sh
    fi

fi
