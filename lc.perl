#! /usr/bin/perl
##
# 文本协议转换成redmine wiki形式
##

$index = 0;
while($line = <>){
    $line =~ s/^des/\* des/;
    $line =~ s/^mod:/\*\* mod: /;
    $line =~ s/^do:/\*\* do: /;
    $line =~ s/^ver:/\*\* ver: /;
    $line =~ s/^in:/\*\* in: /;
    $line =~ s/^out(.*):/\*\* out$1: /;
    $line =~ s/^result:/\*\* result: /;
    $line =~ s/^    ([^\s]+)/\*\*\* $1/;
    $line =~ s/^        ([^\s]+)/\*\*\*\* $1/;
    #$line =~ s/^        (\w+)/\*\*\*\* $1/;
    print $line;
    }
