#!/usr/bin/env bash
# Usage: remove the -hd suffix of file name.
# like: afile-hd.png --> afile.png
# Example: rmSuffix.sh <path_to_resource_file>

rename(){
    FULL_PATH="${1}"
    DIR=`echo ${FULL_PATH%/*}`
    FILE=`echo ${FULL_PATH##*/}`
    FILENAME=`echo ${FILE%%.*}`
    FILETYPE=`echo ${FILE#*.}`
    FILE_SUFFIX=`echo ${FILENAME##*-}`
    FILE_NO_SUFFIX=`echo ${FILENAME%-*}`

    echo 'FULL_PATH: '$FULL_PATH
    echo 'DIR: '$DIR
    echo 'FILE: '$FILE
    echo 'FILENAME: '$FILENAME
    echo 'FILETYPE: '$FILETYPE
    echo 'FILE_SUFFIX: '$FILE_SUFFIX
    echo 'FILE_NAME_NO_SUFFIX: '$FILE_NO_SUFFIX

    echo 'mv '$DIR/${FILE} $DIR/${FILE_NO_SUFFIX}.${FILETYPE}
    mv $DIR/${FILE} $DIR/${FILE_NO_SUFFIX}.${FILETYPE}
}

CUR_DIR="$1"
SUFFIX_TO_RM="$2"
if [ -z $CUR_DIR ]; then
    CUR_DIR=.
fi
for CH_DIR in `ls $1 | awk '/.*-hd\..*/{print}'`
do
    echo
    rename $CUR_DIR/$CH_DIR 
done


