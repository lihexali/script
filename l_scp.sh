#!/bin/bash
#拷贝文件到目标目录
#e.g:
# l_scp /a/b/c_dir /d/e/f_dir --> /d/e/f/c_dir
# l_scp /a/b/c_file /d/e/f_dir/ --> /d/e/f_dir/c_file
# l_scp /a/b/c_file /d/e/f_file --> /d/e/f_file

l_scp(){
    src_f=$1
    dst_f=$2
    #拷文件夹
    if [ -d $src_f ];then
        if [ ! -d $dst_f ];then
            mkdir -p $dst_f
        fi
        cp -rf $src_f $dst_f/
    else
        #拷文件
        f_name=${dst_f%%/*}
        #处理拷文件到文件夹 l_scp /a/b/c/game.pdm /c/d/e/
        if [ ${#f_name} == 0 ] && [ ! -e $dst_f ];then
            echo 'mkdir' $dst_f
            mkdir -p $dst_f
        fi
        cp -f $src_f $dst_f
    fi
}

l_p=/Users/lihex/Documents/mo/chuanqi
c_p=$l_p/client
s_p=$l_p/server
t_p=$l_p/tools
r_p=/tmp/test/abc
r_cp=$r_p/client
r_sp=$r_p/server
r_tp=$r_p/tools

#for client

l_scp  $c_p/egretProperties.json $r_cp
l_scp  $c_p/index.html $r_cp
l_scp  $c_p/libs $r_cp
l_scp  $c_p/bin-debug $r_cp
#for server
l_scp  $s_p/node_modules $r_sp
l_scp  $s_p/route $r_sp
l_scp  $s_p/template $r_sp
l_scp  $s_p/app.js $r_sp
l_scp  $s_p/mainApp.js $r_sp
l_scp  $s_p/serverApp.js $r_sp
l_scp  $s_p/viewApp.js $r_sp
l_scp  $s_p/reset.js $r_sp
#for tools
l_scp  $t_p/data/pdm/game.pdm $r_tp/data/pdm/
l_scp  $t_p/config $r_tp

