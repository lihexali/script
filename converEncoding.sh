#!/bin/sh
# Usage: convertEncoding [path]
list_alldir(){
for file in $1/*
do
if [ -d $file ]
then
    echo $file
    list_alldir $file #在这里递归调用
else
    iconv -f CP936 -t UTF-8 $file > "${file}.changed"
fi
done
}
#下面是定义初始化路径
if [ $# -gt 0 ]
then
list_alldir "$1"
else
list_alldir "."
fi
