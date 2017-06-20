#!/bin/bash
#function:backup src--to--des
#time:20170619

srcpath='/home/httpd/'
despath='/home/bak'

mkdir -p $despath
/bin/tar zcvf  $despath/`date +%Y%m%d`_hsnew.cnfol.com.tar.gz $srcpath


cd  $despath
#delete 15day ago file
find $despath  -maxdepth 1  -type f  -mtime  +15 -exec rm -rvf {} \;
