#change name: 0.png 00000.png
ls *.png |xargs -n 1 -I{}| sed 's/.png//' | awk '{printf("mv %s.png %05d.png\n", $1, $1)}'
