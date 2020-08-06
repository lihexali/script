#!/usr/bin/env bash

## usage: ./appendName <dir> [name]
## example: ./addSpace res_cn _cn

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
                parseDir "${fullpath}" "$2"
            else
                suffix="${filename##*.}" ;
                if [ 'sh' != $suffix ]; then
                    echo "mv ${fullpath} ${fullpath%.*}$2.$suffix"
                    mv "${fullpath}" "${fullpath%.*}$2.$suffix"
                    echo "done!"
                fi
        fi
    done


}


parseDir "$1" "$2"


