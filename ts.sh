#/bin/bash

translate() {
    WORD=`echo $1 | sed -e 's/[[:space:]]/%20/g'`
    URL="http://translate.google.cn/translate_a/t?client=t&text={$WORD}\
        &hl=en&sl=en&tl=zh-CN&ie=UTF-8&oe=UTF-8&multires=1&otf=2\
        &ssel=0&tsel=0&sc=1"
    AGENT="Mozilla/5.0"

    RESULT=`curl -s -A $AGENT $URL`
    RESULT=`echo $RESULT | sed -e 's/\[\{3\}"\([^"]*\)"/_BEG_\1_END_/g;\
        s/_END_[^]]*],\["\([^"]*\)"/\1_END_/g;\
        s/_END_[^_]*_BEG_//g; s/.*_BEG_//g; s/_END_.*//g;'`
}

main() {
    if [ -z "$*" ]
    then
        echo "usage: $0 <word|phrase|sentence>"
        echo "       translate my English words"
        echo "sample: $0 apple"
        echo "        $0 'an apple'"
        echo "        $0 'an apple a day, keep the doctor away.'"

    else
        translate "$1"
        echo "Translate:  $1"
        echo "Result:     $RESULT"
        
    fi
}

main "$*" # run main function

