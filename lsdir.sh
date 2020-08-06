#!/bin/sh
#使用bash做为默认shell
list_alldir(){
for file in $1/*
do
if [ -d $file ]
then
    echo $file
    list_alldir $file #在这里递归调用
else
    #这里处理文件
    #echo "do sth to a file"
    echo $file
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
