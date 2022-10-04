---
title: Mysql binlog相关使用笔记
date: 2021-07-16 12:29:50
tags:
categories: mysql
---

# 开启bin-log
```
vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

<!-- more -->

```
[mysqld]区块添加
log-bin=mysql-bin(也可指定二进制日志生成的路径，如：log-bin=/opt/Data/mysql-bin)
server-id=1
binlog_format=MIXED(加入此参数才能记录到insert语句)
```

## 重启Mysql

```
systemctl restart mysql
//或者
service mysql restart 
```
## 查看binlog日志是否开启

```
mysql> show variables like 'log_%';
```

# 测试
## 链接数据库
## 向数据表中插入一行
## 查看bin-log
```
mysqlbinlog -v /var/log/mysql/mysql-bin.000001
```
## 导出，可以指定时间段
```
mysqlbinlog --base64-output=decode-rows -v --start-date='2014-09-16 14:00:00' --stop-date='2014-09-16 14:20:00' /var/log/mysql/mysql-bin.000001 >/tmp/log.sql
```

推荐：
https://www.cnblogs.com/Presley-lpc/p/9619571.html
https://blog.csdn.net/Allenzyg/article/details/106446992