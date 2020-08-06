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
                parseDir "${fullpath}"
            else
                suffix="${filename##*.}" ;
                if [ 'cpp' == $suffix -o 'h' == $suffix ]; then
                    echo "parsing ${fullpath}"
                    sed -i -r "s/[^\x00-\x7f]$/\0 /" "${fullpath}"
                    chmod 777 "${fullpath}"
                    echo "done!"
                fi
        fi
    done


}

parseDir "$1"


