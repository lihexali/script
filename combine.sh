#!/bin/bash 
# 把这些日志FishingJoy2_000371_baoRuan_1.0.8_50.log
# 合并输出到
# 371.txt里面

FILE_NAME=
for f in `ls *.log`
do
    FILE_NAME=$FILE_NAME:`echo $f \
        | sed -r 's/(.*)_.*/\1/' \
        | sed -r 's/.*([0-9]{6}).*/\1/' \
        | sed -r 's/[0]*([^0]+)/\1/' \
        | sed -r 's/^0.*/0/'`
done

FILE_NAME=`echo $FILE_NAME | sed 's/:/_/g' | sed 's/^_//g'`
echo $FILE_NAME

for f in `ls *.log`
do
     cat $f |sed -E 's/ChannelID: (.*)/ChannelID: 000000\1/g' | sed -E 's/(ChannelID:.*)([0-9]{6,6})$/ChannelID: \2/g' | sed -E '/^\s/!s/(.*)/|\1/g'  | sed ':a;N;s/\n/\t/;ba;' | sed -E 's/\s//g' | sed 's/^..//g' >> $FILE_NAME'.txt'
done
