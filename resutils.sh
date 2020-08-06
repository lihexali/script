#cat GuildMineLayerSkin.exml |grep source | gsed -r 's/.*source="([^"]+)".*/\1/pg'
filsource(){
cat $1 | grep source | gsed -r  's/.*source="([^"]+)".*/\1/g'
}

staapper(){
    local num=$(ack "$1" | wc -l | col 1)
    echo $1 $num
}

filetest(){
    filsource $1 | xargs -n 1 staapper
}

#filsource GuildMineLayerSkin.exml | xargs -I{} ./a.sh {} |grep " 1$"

#a.sh
#num=$(ack "$1" | wc -l)
#echo $1 $num

