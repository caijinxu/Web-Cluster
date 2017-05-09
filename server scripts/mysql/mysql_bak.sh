/bin/bash
##################################################
#Mysql主从同步一键备份主库，记录binlog记录
#Create by caijinxu
##################################################
MYUSER=root
MYPASS="YOUPASS"
MYSOCK=/data/3306/mysql.sock
MAIN_PATH=/server/backup
DATA_PATH=/server/backup
LOG_FILE=${DATA_PATH}/mysqllogs_`date +%F`.log
DATA_FILE=${DATA_PATH}/mysql_backup_`date +%F`.sql.gz
MYSQL_PATH=/usr/local/mysql/bin
MYSQL_CMD="$MYSQL_PATH/mysql -u$MYUSER -p$MYPASS -S $MYSOCK"
MYSQL_DUMP="$MYSQL_PATH/mysqldump -u$MYUSER -p$MYPASS -S $MYSOCK -A -B --master-data=1 --single-transaction -e"
${MYSQL_DUMP} |gzip>$DATA_FILE; 
