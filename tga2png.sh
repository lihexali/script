for f in $(find . -name "*.[tT][gG][aA]")
do
    echo $f  
    echo ${f%.*}
    ./resize_single.py $f ${f%.*}.png 1
done
