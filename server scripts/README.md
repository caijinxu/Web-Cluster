sysctl.conf  优化好的内核文件模板与optimization.sh 文件配合使用放在 /server/scripts/下;
host 为集群自定义host文档，会被optimization.sh调用，放在 /server/scripts/下;
optimization.sh 系统初始化脚本，放在 /server/scripts/下;

Backup.sh 备份目标目录到指定目录，并删除指定目录下15天前文件；

rsyncfile.sh和rsynchttpd.sh 两个代码同步脚本，注意！两个脚本rsyncd服务端和客户端不一样：
rsyncfile.sh脚本将本地代码同步到两个开启rsyncd服务器，缺点：如果只修服务器端文件内容，同步时被修改文件不会被覆盖，有两边不一致可能。
rsynchttpd.sh脚本将开启rsyncd服务端文件同步到本地，文件完全一致，建议使用这种方式做代码同步。
