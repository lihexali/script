#!/bin/bash  
#$1 change desc file
#$2 target file
seq()
{
    total=$1;
    while [ $total -le $3 ];do
        echo $total
        total=$(($total+$2));
    done;
}

words=`cat $1`;
array=($words)
size=${#array[@]}

cp $2 $2.orig
for s in $(seq 1 2 $size)
do
    echo $s
    src=${array[$(($s-1))]}
    echo $src
    dst=${array[$s]}
    echo $dst
    #echo 's/$src/$dst/g'
    sed -i "s/$src/$dst/" $2
done

echo "--" 
