#!/bin/bash

for f in `ls ~/Desktop/ui_panel/`
do
    pf='ui_common\/'$f
    af='ui_panel\/'$f
    echo $pf $af
    perl -i -p -e's/'$pf'/'$af'/g' $(ack -f --json)
done
