#!/bin/bash
# Check the RESO_DEF Macro is well defined
# Usage: ./RESO_DEF.sh [dir] [flag]
# flag=v means run on verbose mode
# example: ./RESO_DEF.sh ./src v

DIR=.
VERBOSE=''

if [ "$#" -ne 0 ]; then
    if ! [ -e "$1" ]; then
        echo "$1 not found" >&2
        exit 1
    fi

    if ! [ -d "$1" ]; then
        echo "$1 not a directory" >&2
        exit 1
    fi
    DIR="$1"
    VERBOSE="$2"
fi

echo 'Working in '$DIR

# parse sigle-line RESO_DEF define
ack -A 7 \
    --type=cpp --type=objc --type=objcpp \
    --ignore-file=match:/GameConfig.h/ 'RESO_DEF' $DIR \
    | sed -n '/RESO_DEF.*};$/p' \
    | sed 's/\/\/.*//' \
    | sed 's/.*.cpp-[0-9]\+[-:]//' \
    | ./step1.py \
    | sed -E 's/RESO_DEF[^\{]+\{(.*)\};$/\1/' \
    | ./step2.py "$VERBOSE"

# parse multi-line RESO_DEF define
ack -A 7 --type=cpp --type=objc --type=objcpp \
    --ignore-file=match:/GameConfig.h/ 'RESO_DEF' $DIR \
    | sed '/RESO_DEF.*};$/d' \
    | sed -n '/RESO_DEF/,/};/p' \
    | sed 's/\/\/.*//' \
    | sed 's/.*.cpp-[0-9]\+[-:]//' \
    | ./step1.py \
    | sed -E 's/RESO_DEF[^\{]+\{(.*)\};$/\1/' \
    | ./step2.py "$VERBOSE"

