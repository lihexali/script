#!/bin/env bash

## usage: addSpace <dir>
## example: ./addSpace src

is_directory()
{
  local DIR_NAME=$1
  if [ ! -d $DIR_NAME ]; then
    return 1
  else
    return 0
  fi
}

parseDir()
{

    local dir=$1
    local versionCode=$2
    local versionName=$3

    if  is_directory "${dir}" 
        then :
        else
            echo "error,please pass me a dirctory";
            exit 1
    fi

    echo "working in ${dir}"

    local filelist=`ls "${dir}"`

    for filename in $filelist
    do
        local fullpath="${dir}"/"${filename}";
        if is_directory "${fullpath}"
            then
                if [ -f $fullpath/build_native.sh ]; then
                    parseDir "${fullpath}" "${versionCode}" "${versionName}"
                else
                    return
                fi
            else
                build_native_file="${dir}"/"build_native.sh"
                if [ "AndroidManifest.xml" = $filename ]; then
                    if [ -e "${build_native_file}" ]; then
                        #echo "parsing ${fullpath}"
                        echo "parsing ${fullpath}"
                        sed -i -r "s/(android:versionCode=\")[^\"]+\"/\1${versionCode}\"/" "${fullpath}"
                        sed -i -r "s/(android:versionName=\")[^\"]+(\".*)/\1${versionName}\2/" "${fullpath}"
                        echo "done!"
                    fi
                fi
        fi
    done
}

if [ $# -ne 3 ]
then
   echo "Usage: changeVersion.sh <path> <versionCode> <versionName>"
else
   echo $1 $2 $3
fi

parseDir "$1" "$2" "$3"


