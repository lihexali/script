#!/usr/bin/env bash
# Usage: add suffix at the end of the png or jpeg file name.
# like: afile.png --> afile_cn.png
# Example: addSuffix.sh <path_to_resource_file> <suffix>

rename(){
    FULL_PATH="${1}"
    ADD_SUFFIX="${2}"
    DIR=`echo ${FULL_PATH%/*}`
    FILE=`echo ${FULL_PATH##*/}`
    FILENAME=`echo ${FILE%%.*}`
    FILETYPE=`echo ${FILE#*.}`
    FILE_SUFFIX=`echo ${FILENAME##*-}`
    FILE_NO_SUFFIX=`echo ${FILENAME%%-*}`

    echo 'FULL_PATH: '$FULL_PATH
    echo 'DIR: '$DIR
    echo 'FILE: '$FILE
    echo 'FILENAME: '$FILENAME
    echo 'FILETYPE: '$FILETYPE
    echo 'FILE_SUFFIX: '$FILE_SUFFIX
    echo 'FILE_NAME_NO_SUFFIX: '$FILE_NO_SUFFIX

    echo 'mv '$DIR/${FILE} $DIR/${FILE_NO_SUFFIX}${ADD_SUFFIX}.${FILETYPE}
    mv $DIR/${FILE} $DIR/${FILE_NO_SUFFIX}${ADD_SUFFIX}.${FILETYPE}
}

CUR_DIR="$1"
ADD_SUFFIX="$2"
if [ -z $ADD_SUFFIX ]; then
   echo "Please input suffix at parm 2" 
   exit 1
fi

if [ -z $CUR_DIR ]; then
    CUR_DIR=.
fi
for CH_DIR in `ls $1 | awk '/\.png|\.jpg/{print}'`
do
    echo
    rename $CUR_DIR/$CH_DIR  $ADD_SUFFIX
done


