---
title: mysql（mariadb）常用命令
date: 2020-08-14 11:09:26
tags:
---

> 首先了解一下`SQL`的注释

单行语句进行注释
```sql
SELECT * FROM USERS; --查询所有用户信息
```

<!-- more -->


多行注释

```sql
/*
切换到USER数据库
查询所有表信息
*/
USE USER;
SHOW TABLES;
```
注释快捷键
> 选中需要注释的语句
先Ctrl+k，再Ctrl+c
注释成功
取消注释
先Crtrl+k，在Ctrl+u


## 查看支持的表引擎
```SQL
SHOW ENGINES;
SHOW VARIABLES LIKE "%STORAGE_ENGINE%";
```

## 查看创建表语句
```SQL
SHOW CREATE TABLE `TBALE`
```

## 查看表status
```SQL
SHOW TABLE STATUS FROM `DATABASE` WHERE NAME=`TABLE` \G
```
## 修改表引擎
```SQL
ALTER TABLE `TBALE` ENGINE=MEMORY
```

## 查看mysql的数据文件存放位置
```SQL
SHOW VARIABLES LIKE "%DIR%";
```
数据库文件默认在：`cd /usr/share/mysql`
配置文件默认在：`/etc/my.cnf`

———————————–

数据库目录：`/var/lib/mysql/`
配置文件：`/usr/share/mysql`(mysql.server命令及配置文件)
相关命令：/usr/bin(mysqladmin、mysqldump等命令)(*mysql的一种安全启动方式：/usr/bin/mysqld_safe –user=root &)
启动脚本：/etc/rc.d/init.d/

首先你可以使用以下的命令来寻找MySQL
```
[root@stuhome /]# find / -name “mysql” -print
```
一般来说mysql是放在/usr/local/mysql/下的。
然后在其bin目录下有个mysql_config文件，vi之，你会看见这么一句：
ldata=’/usr/local/mysql/var’
rpm安装默认目录：
数据文件：/var/lib/mysql/
配置文件模板：/usr/share/mysql
mysql客户端工具目录：/usr/bin
日志目录：/var/log/
pid，sock文件目录：/tmp/

## 设置组合主键索引
使用baiprimary key(字段1, 字段2, ...)的语句进行设置。
一个表中最du多只能有一个主键，zhi也可以没有。一个主键既可dao以是单一的字段构成，也可以是多个字段联合构成，如果是单一字段，只需在该字段后面标记primary key即可，如果是多个字段联合构成，则需要采用最开始介绍的那种方式设置。
在部分数据库的图形化工具中（如Access、SQL Server等），在表设计的界面上，可以按住Ctrl键，然后选择要设置为联合主键的字段，都选好之后再按右键选择“设置为主键”。
alter table Table_1 add constraint pk_name primary key (id,name)设置Table_1表的id,name为主键

## 更改表名
```
ALTER TABLE table_name RENAME [TO] new_name;
```

##创建索引
```
create index `id_name` on categories (`id`, `name`);
```

## 更改字段信息
```
alter table categories modify column id mediumint auto_increment primary key ;
```

## 删除索引
```
drop index id_name on categories;
```

#其他
```SQL
SHOW DATABASES                                //列出 MySQL Server 数据库。

SHOW TABLES [FROM db_name]                    //列出数据库数据表。

SHOW TABLE STATUS [FROM db_name]              //列出数据表及表状态信息。

SHOW COLUMNS FROM tbl_name [FROM db_name]     //列出资料表字段

SHOW FIELDS FROM tbl_name [FROM db_name]，DESCRIBE tbl_name [col_name]。

SHOW FULL COLUMNS FROM tbl_name [FROM db_name]//列出字段及详情

SHOW FULL FIELDS FROM tbl_name [FROM db_name] //列出字段完整属性

SHOW INDEX FROM tbl_name [FROM db_name]       //列出表索引。

SHOW STATUS                                  //列出 DB Server 状态。

SHOW VARIABLES                               //列出 MySQL 系统环境变量。

SHOW PROCESSLIST                             //列出执行命令。

SHOW GRANTS FOR user                         //列出某用户权限
```

#建表语句

```sql
create table files(
 username varchar(50),
 file varchar(200) not null,
 create_time timestamp not null default CURRENT_TIMESTAMP,
 filename varchar(100) default null,
 md5 char(32) not null default '',
 id int(11) not null auto_increment primary key) engine=myisam default charset=utf8mb4 collate=utf8mb4_unicode_ci;
```

#MySQL(Unix时间戳、日期)转换函数
> unix_timestamp()

```
mysql> select unix_timestamp();
+``------------------+
| unix_timestamp()   |
+``------------------+
|    1464590043      |
+``------------------+
```

> unix_timestamp(date)

```
mysql> select unix_timestamp('2016-05-30');
+------------------------------+
| unix_timestamp('2016-05-30') |
+------------------------------+
|                   1464537600 |
+------------------------------+
 
mysql> select unix_timestamp('2016-05-30 14:35:21');
+---------------------------------------+
| unix_timestamp('2016-05-30 14:35:21') |
+---------------------------------------+
|                            1464590121 |
+---------------------------------------+
```

 

> from_unixtime(unix_timestamp)

```
mysql> select from_unixtime(1464590043);
+---------------------------+
| from_unixtime(1464590043) |
+---------------------------+
| 2016-05-30 14:34:03       |
+---------------------------+
```

 

> from_unixtime(unix_timestamp,format)

```
mysql> select from_unixtime(1464590043, '%Y %D %M %h:%i:%s %x');
+---------------------------------------------------+
| from_unixtime(1464590043, '%Y %D %M %h:%i:%s %x') |
+---------------------------------------------------+
| 2016 30th May 02:34:03 2016                       |
+---------------------------------------------------+
```

修改密码ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';

# 如何删除mysql 主键索引
如果一个主键是自增长的，不能直接删除该列的主键索引，
应当先取消自增长，再删除主键特性

```
alter table 表名 drop primary key; --【如果这个主键是自增的，先取消自增长.】
```

具体方法如下:
```
alter table articles modify id int ; --【重新定义列类型】

alter table articles drop primary key;
```

# 添加主键索引

innodb逐渐使聚簇索引，myisam不是[待考究]

```
ALTER TABLE users ADD PRIMARY KEY (id);
```

删除
```
ALTER TABLE users DROP primary key; --删除前要将auto_increment去掉
```

# 添加其他索引
```
CREATE INDEX index_name ON users(username);
```

# MySQL 查看执行计划

```
EXPLAIN SELECT * FROM users WHERE id > 1;
```

Mysql8.0新增`EXPLAIN ANALYZE`

```
EXPLAIN ANALYZE SELECT * FROM users WHERE id > 0;
```

# 执行计划中`extra`的描述
```
Using where：表示优化器需要通过索引回表查询数据；
Using index：表示直接访问索引就足够获取到所需要的数据，不需要通过索引回表；
Using index condition：在5.6版本后加入的新特性（Index Condition Pushdown）;
Using index condition 会先条件过滤索引，过滤完索引后找到所有符合索引条件的数据行，随后用 WHERE 子句中的其他条件去过滤这些数据行；
Using where && Using index
```

# 更改表的引擎

```
ALTER TABLE users ENGINE = myisam;
```

# Innodb的count效率在mysql8测试已经不再低于myisam了

# 蠕虫复制

```sql
INSERT INTO users SELECT * FROM users_1;
```
下面的SQL可以指定列，用于解决唯一约束的问题
```sql
INSERT INTO users(username,password) SELECT username,password FROM users_d;
```

# 查看状态
```sql
show status
```

```sql
show table status
```
> 可以通过`Comment`字段查看表是不是视图

# 查看触发器
`show triggers`

# 权限相关

```sql
show grants for `username`
grant all on *.* to `username`@`%`
revoke all on *.* from `username`@`%`
flush privileges
```