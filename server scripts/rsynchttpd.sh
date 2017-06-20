#!/bin/bash
while true
do
	/usr/bin/rsync -avz  --progress --exclude-from=/usr/local/scripts/rsync_excludelist.txt     --password-file=/etc/rsync.passwd  --delete  rsync@172.30.10.21::html /home/html
	sleep 5
done

