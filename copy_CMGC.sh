for file in `ls`
do 
       new=`echo $file | sed -r 's/([0-9][0-9][0-9][0-9][0-9][0-9]).*/\1/g'`
       echo 'cp '$file' to '$new
       cp -rf $file $new
       dest1='/cygdrive/g/FishingJoy2dev1_11pkg/FishGame/android/'$new'/Resource_android/'
       new2=`echo $new \
        | sed -E 's/(^[0-9]{6}).*/\1/' \
        | sed -E 's/[0]*([^0]+)/\1/' \
        | sed -E 's/^0.*/0/'`
       echo 'new2= '$new2
       dest2='/cygdrive/g/FishingJoy2dev1_11pkg/FishGame/android/publish/CMGC_Charges/Charge'$new2'.xml'
       cp $new'/assets/Charge.xml' $dest1
       cp $new'/assets/Charge.xml' $dest2
       #echo 'cp '$new'/assets/Charge.xml '$dest1
       #echo 'cp '$new'/assets/Charge.xml '$dest2
done
