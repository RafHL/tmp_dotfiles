xrdb -query | grep $1 | grep -oh "\w*#\w*" | tail -1
