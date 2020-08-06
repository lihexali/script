#!/bin/bash - 
#===============================================================================
#
#          FILE: stat.sh
# 
#         USAGE: cat /tmp/noused_res.txt |xargs -I{} ./stat.sh {} | tee /tmp/noused_res_incode.txt
# 
#   DESCRIPTION: 查找字符串是否在文件中出现过
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/01/17 10:11
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

file_name=$1
ack $file_name | wc -l | grep -v 0$ | awk '{printf "'$file_name' %s\n",$0}'


