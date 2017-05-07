#!/bin/bash
################################
#不停主库一键批量配置mysql主从复制
#Create by caijinxu
###############################
MYUSER=root
MYPASS="youpasswd"
MYSOCK=/data/3306/mysql.sock
MAIN_PATH=/server/backup
DATA_PATH=/server/backup
LOG_FILE=${DATA_PATH}/mysqllogs_`date +%F`.log
DATA_FILE=${DATA_PATH}/mysql_backup_`date +%F`.sql.gz
MYSQL_PATH=/usr/local/mysql/bin
MYSQL_CMD="$MYSQL_PATH/mysql -u$MYUSER -p$MYPASS -S $MYSOCK"
#recover
cd ${DATA_PATH}
gzip -d mysql_backup_`date +%F`.sql.gz
$MYSQL_CMD<mysql_backup_`date +%F`.sql
#config slave
cat |$MYSQL_CMD<<EOF
CHANGE MASTER TO
MASTER_HOST='10.0.*.*',
MASTER_PORT=3306,
MASTER_USER='rep',
MASTER_PASSWORD='password',
EOF
$MYSQL_CMD -e "star slave;"
$MYSQL_CMD -e "show slave status\G"|egrep "IO_Running|SQL_Running">$LOG_FILE
mail -s "mysql slave result" 2423345@qq.com<$LOG_FILE
