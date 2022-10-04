---
title: 查看mysql数据库容量大小
date: 2021-07-02 11:24:40
tags:
categories: mysql
---

# 第一种情况

## 查询所有数据库的总大小，方法如下：

```sql
mysql> use information_schema;
mysql> select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data from TABLES;
+-----------+
| data      |
+-----------+
| 3052.76MB |
+-----------+
1 row in set (0.02 sec)
```

<!-- more -->

## 统计一下所有库数据量 
每张表数据量`=AVG_ROW_LENGTH*TABLE_ROWS+INDEX_LENGTH`
```sql
SELECT SUM(AVG_ROW_LENGTH*TABLE_ROWS+INDEX_LENGTH)/1024/1024 AS total_mb FROM information_schema.TABLES 
```
## 统计每个库大小：
```
SELECT table_schema,SUM(AVG_ROW_LENGTH*TABLE_ROWS+INDEX_LENGTH)/1024/1024 AS total_mb FROM information_schema.TABLES group by table_schema;  
```

# 第二种情况

>查看指定数据库的大小，比如说：数据库test，方法如下：

```sql
mysql> use information_schema;
mysql> select concat(round(sum(DATA_LENGTH/1024/1024),2),'MB') as data from TABLES where table_schema='test';
+----------+
| data     |
+----------+
| 142.84MB |
+----------+
1 row in set (0.00 sec)
```
## 查看所有数据库各容量大小
```
select
table_schema as '数据库',
sum(table_rows) as '记录数',
sum(truncate(data_length/1024/1024, 2)) as '数据容量(MB)',
sum(truncate(index_length/1024/1024, 2)) as '索引容量(MB)'
from information_schema.tables
group by table_schema
order by sum(data_length) desc, sum(index_length) desc;
```
## 查看所有数据库各表容量大小
```
select
table_schema as '数据库',
table_name as '表名',
table_rows as '记录数',
truncate(data_length/1024/1024, 2) as '数据容量(MB)',
truncate(index_length/1024/1024, 2) as '索引容量(MB)'
from information_schema.tables
order by data_length desc, index_length desc;
```
## 查看指定数据库容量大小
例：查看mysql库容量大小
```
select
table_schema as '数据库',
sum(table_rows) as '记录数',
sum(truncate(data_length/1024/1024, 2)) as '数据容量(MB)',
sum(truncate(index_length/1024/1024, 2)) as '索引容量(MB)'
from information_schema.tables
where table_schema='mysql';　
```
## 查看指定数据库各表容量大小
例：查看mysql库各表容量大小
```
select
table_schema as '数据库',
table_name as '表名',
table_rows as '记录数',
truncate(data_length/1024/1024, 2) as '数据容量(MB)',
truncate(index_length/1024/1024, 2) as '索引容量(MB)'
from information_schema.tables
where table_schema='mysql'
order by data_length desc, index_length desc;
```


> 原文地址：https://www.cnblogs.com/--smile/p/11451238.html