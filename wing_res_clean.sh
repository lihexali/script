ui_path=/Users/lihex/Documents/mo/chuanqi_Doc/assets/chuanqi_wing/resource/ui/
ui_common=$ui_path/ui_common
ui_src=/Users/lihex/Documents/mo/chuanqiGUI/assets/chuanqi_wing/src
pushd $ui_common

res_files=$(ls |grep  -E ".png|.jpg") 
for f in $res_files
do
    #echo $f
    f_n=${f%%.*}
    f_num=$(ack --group $f_n $ui_src | wc -l)
    echo $f_num $f
done
