mv_url="$1"
file_name=${mv_url#*//}
file_name=${file_name#*/}
file_name=${file_name#*/}
file_name=${file_name%%/*}
save_name=${file_name}.mp4
echo "File name: "${file_name}
echo "Downloading: "${mv_url}
echo "Saving: "${save_name}
echo "--------------------------"
ffmpeg -i  ${mv_url}  -c copy -bsf:a aac_adtstoasc ${save_name}

