# linux version
ts(){

words=""
for word in $@; 
do
    words="$words$word "
done

curl -s \
        "http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=dict.top" \
     -d \
	"type=AUTO& i=$words&doctype=json&xmlVersion=1.4&keyfrom=fanyi.web&ue=UTF-8&typoResult=true&flag=false" \
        | sed -r -n 's/.*tgt":"([^"]+)".*/\1/p' ;

return 0;
}

tss(){
result=`curl -s \
        "http://dict-co.iciba.com/api/dictionary.php?w=$1" `;

echo $result | sed -r -n 's/.*<ps>([^<]+)<\/ps>.*/\1/p'; 
echo $result | sed -r -n 's/.*<pos>([^<]+)<\/pos>.*/\1/p'; 
echo $result | sed -r -n 's/.*<acceptation>([^<]+)<\/acceptation>.*/\1/p'; 

#examples
echo $result \
    | sed 's/.*<\/acceptation>//g' \
    | sed 's/<trans>//g' \
    | sed 's/<orig>//g' \
    | sed 's/<[^<>]*>//g' ;

#Evaluate whether audio information
is_empty=`echo $result | grep pron`
if [ "$is_empty" ]; then
    audio=`echo $result |sed -r 's/.*<pron>([^<]+)<\/pron>.*/\1/'`
    mpg123 -q $audio &
fi

return 0;

}


# Mac Version
# notic: ^M^L = Ctrl+v Ctrl+Enter Ctrl+v Ctrl+l
tss(){
result=`curl -s \
        "http://dict-co.iciba.com/api/dictionary.php?w=$1" `;

echo $result | sed -E -n 's/.*<ps>([^<]+)<\/ps>.*/\1/p'; 
echo $result | sed -E -n 's/.*<pos>([^<]+)<\/pos>.*/\1/p'; 
echo $result | sed -E -n 's/.*<acceptation>([^<]+)<\/acceptation>.*/\1/p'; 

#examples
echo $result \
    | sed 's/.*<\/acceptation>//g' \
    | sed 's/<trans>//g' \
    | sed 's/<orig>//g' \
    | sed 's/<[^<>]*>//g' ;

#Evaluate whether audio information
is_empty=`echo $result | grep pron`
if [ "$is_empty" ]; then
    audio=`echo $result |sed -E 's/.*<pron>([^<]+)<\/pron>.*/\1/'`
    mpg123 -q $audio &
fi

return 0;

}
