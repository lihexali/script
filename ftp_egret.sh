#!/bin/bash
version=
if [ -n "$1" ];then 
    version=$1
    if [ ${#version} -lt 12 ]; then
        echo '[err] channel id must be 12 digitals : '$1
        exit 1
    fi
else
    echo 'USAGE: ftp_egret.sh 201502221223'
    exit 1
fi

zipfile=$version'.zip'
echo '--->FTP upload '$zipfile

ftp -A -n<<!
open 120.132.76.241
user sjwemdr  simY@s60X
binary
hash
cd /webftp/data/nfs
lcd /Users/lihex/Documents/UnderWorldEgret/client/release/android/
mput $zipfile
close
bye
!
