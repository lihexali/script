#/bin/bash
# 精简checkSMS.log
# 只输出：
# 1. 渠道号
# 2. 版本名称
# 3. 版本号
# 4. 电信代码
# 4. 联通代码

LOGFILE="checkSMS.log"

awk '/CHANNEL_ID|Version Name|Version Code|DianXin Code|Unicom Code/{where=NR;print}NR==where+1 && where!=0 {print}' $LOGFILE \
    | sed '/Debug*/d' | sed '/CHANNEL_ID/{x;p;x;}'
