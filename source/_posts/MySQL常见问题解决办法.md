---
title: MySQL常见问题解决办法
date: 2021-02-01 12:30:57
tags:
---

# 字符校对规则问题
查询视图时报错：java.sql.SQLException: Illegal mix of collations (utf8mb4_general_ci,IMPLICIT) and (utf8mb4_0900_ai_ci,IMPLICIT) for operation '='；

本地环境:`mysql8.0.13`

异常提示排序规则编码混乱，mysql8.0.1之后的默认COLLATE为utf8mb4_0900_ai_ci；

检查视图中所包含的表发现其中一个建表时 没有设置编码，并且其他的表设置的是 CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci；因此导致混乱；

查看当前数据库的默认编码：

```shell
mysql> show variables where Variable_name like 'collation%';
```


查看各表编码：
```shell
mysql> show create table ‘table_name’;
```
 

解决方案给没有设置编码的表重新设置一下：
```shell
mysql> alter table table_name default character set utf8mb4 collate=utf8mb4_general_ci;
```


这样设置只针对表的，但是表中字段未修改：
```shell
mysql> ALTER TABLE table_name convert to CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

修改完成以后，重新创建视图！！！！

# 排序内存溢出问题
报错：
`SQLSTATE[HY001]: Memory allocation error: 1038 Out of sort memory, consider increasing sort buffer size`

找到mysql配置文件（我的是`/etc/mysql/mysql.conf.d/mysqld.cnf`）, 添加一行
```
sort_buffer_size        = 16M
```
重启数据库，报错继续加大

# 数据类型相关
记录datetime到毫秒
5.6 之后可以将字段类型设置为datetime(3), 其中的数字表示精度，三位精确到毫秒

# Incorrect key file for notes
解决方案（目前使用myisam引擎）
```sql
optimize table notes;
```
如果不行就google一下