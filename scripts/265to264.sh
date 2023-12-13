mkdir h264vids
for f in *.mkv
do
    ffmpeg -i "$f" -map 0 -c copy -c:v libx264 -crf 23 -preset medium h264vids/"${f%.*}.mkv"
done
