#!/bin/bash
for file in `ls . | sed -n '/^[0-9]..../p'` 
do
    if [ -e "./$file/assets" ];then 
        echo "./$file/assets"
        rm -rf "./$file/assets" 
    fi
done
