##功能：找出两个文件夹的差异，并把差异文件输出到/tmp目录
##说明：目录写死的，需要修改src_dir/dst_dir/参数

src_dir=/Users/lihex/Documents/mo/chuanqi/client/bin-release/product/12.6.22
dst_dir=/Users/lihex/Documents/mo/chuanqi/client/bin-release/product/12.6.20

echo "#src_dir=$src_dir"
echo "#dst_dir=$dst_dir"

root_dir=${src_dir##*/}
echo "#root_dir=$root_dir"

bak_dir=/tmp
bak_dst_dir=$bak_dir/$root_dir'_'$(date +%s)
mkdir -p $bak_dst_dir
echo "#bak_dst_dir=$bak_dst_dir"

#临时文件
tmp_f='/tmp/tm_diff'$(date +%s)
diff_files=`diff -rq $src_dir $dst_dir`

#内容差异文件信息
F_files=`echo "$diff_files" \
    | grep '^F' \
    | awk '{print $2}'`

#文件缺失差异信息
O_files=`echo "$diff_files" \
    | grep '^O' `

#拷贝差异文件
for f in $F_files
do
    f_name=${f##*/}

    #构建tmp目录结构
    tmp_dir=${f#*$root_dir}
    tmp_dir=${tmp_dir%/*}
    tmp_dir=${tmp_dir#*/}
    final_dst_dir=$dst_dir/$tmp_dir
    tmp_dir=$bak_dst_dir/$tmp_dir

    echo cp $f $final_dst_dir/$f_name
    echo cp $f $tmp_dir/$f_name
    mkdir -p $tmp_dir
    cp "$f" "$tmp_dir/$f_name"

done

#拷贝/删除缺失文件
if [ -z "$O_files" ];then
    exit
fi
echo "$O_files" | while read f
do
    dir_name=`echo "$f" | sed -E -n 's/.*in ([^:]+):.*/\1/p' `
    file_name=`echo "$f" | sed -E -n 's/[^:]+: (.*$)/\1/p' `

    sf_path=$dir_name/$file_name
    append_dir_name=${dir_name#*$root_dir}
    dst_dir_name=$dst_dir/$append_dir_name
    df_path=$dst_dir_name/$file_name

    if [[ "$dir_name"x == "$src_dir"*x ]];then
        #s-d对拷
        echo cp -rf $sf_path $df_path

        #构建tmp目录结构
        tmp_dir=${sf_path#*$root_dir}
        tmp_dir=${tmp_dir%/*}
        tmp_dir=${tmp_dir#*/}
        tmp_dir=$bak_dst_dir/$tmp_dir
        if [ -d "$sf_path" ];then
            #s-t对拷
            if [ -n "$append_dir_name" ];then
                echo mkdir -p "$bak_dst_dir/$append_dir_name"
                echo cp -rf $sf_path "$bak_dst_dir/$append_dir_name"
                mkdir -p "$bak_dst_dir/$append_dir_name"
                cp -rf "$sf_path" "$bak_dst_dir/$append_dir_name"
            else
                echo cp -rf $sf_path $tmp_dir/$file_name
                cp -rf "$sf_path" "$tmp_dir/$file_name"
            fi
        else
            #s-t对拷
            if [ -n "$append_dir_name" ];then
                echo mkdir -p "$bak_dst_dir/$append_dir_name"
                echo cp "$sf_path" "$bak_dst_dir/$append_dir_name/$file_name"
                mkdir -p "$bak_dst_dir/$append_dir_name"
                cp "$sf_path" "$bak_dst_dir/$append_dir_name/$file_name"
            else
                echo cp "$sf_path" "$tmp_dir/$file_name"
                cp "$sf_path" "$tmp_dir/$file_name"
            fi
        fi
    else
        echo mv $df_path /tmp
    fi
done

