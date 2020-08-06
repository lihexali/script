#! /usr/bin/perl

$searching_for_end = 0;
while ($line = <>){
    if (($line !~  /BEGIN TRANSACTION/) && ($line !~ /COMMIT/) && ($line !~ /sqlite_sequence/) && ($line !~ /CREATE UNIQUE INDEX/) && ($line !~ /PRAGMA/)){
        if ($line =~ /CREATE TABLE .*/){
                $searching_for_end = 1;
        }

        if ($line =~ /DROP TABLE IF EXISTS \"([a-z_]*)\"(.*)/){
                $name = $1;
                $sub = $2;
                $sub =~ s/\"//g;
                $line = "DROP TABLE IF EXISTS $name$sub\n";
        }
        elsif ($line =~ /CREATE TABLE \"([a-z_]*)\"(.*)/){
                $name = $1;
                $sub = $2;
                $sub =~ s/\"//g;
                $line = "CREATE TABLE IF NOT EXISTS $name$sub\n";
        }
        elsif ($line =~ /INSERT INTO \"([a-z_]*)\"(.*)/){
                $line = "INSERT INTO $1$2\n";
                $line =~ s/\"/\\\"/g;
                $line =~ s/\"/\'/g;
        }else{
                $line =~ s/\'\'/\\\'/g;
        }
        $line =~ s/([^\\'])\'t\'(.)/$1THIS_IS_TRUE$2/g;
        $line =~ s/THIS_IS_TRUE/1/g;
        $line =~ s/([^\\'])\'f\'(.)/$1THIS_IS_FALSE$2/g;
        $line =~ s/THIS_IS_FALSE/0/g;
        $line =~ s/AUTOINCREMENT/AUTO_INCREMENT/g;
        if ($searching_for_end){
                $line =~ s/\"/\`/g;
                $line =~ s/\'/\`/g;
        }
        if (($searching_for_end) && ($line =~/.*\);/)){
                $line =~ s/\"/\`/g;
                $searching_for_end = 0;
        }
        print $line;
    }
}

