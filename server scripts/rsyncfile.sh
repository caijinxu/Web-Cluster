#!/bin/bash
#Des: Monitor and implement synchronization scripts tomcat file


SRC=/home/httpd/
HOSTS=(10.10.1.79 10.10.41.24)
DST=new
USER=www
Log=/home/httpd/rsync.log


for HOST in ${HOSTS[@]};do
	/usr/bin/rsync -avzu --delete --password-file=/etc/hs.pas $SRC $USER@$HOST::$DST && echo "${files} was rsynced at $DATE, send files to $HOST" >> $Log
done
