---
title: postgresql
date: 2020-09-28 20:31:11
tags:
---

sudo -i -u postgres 登录
\l列出所有数据库
\c 数据库名 选择数据库
\d 列出数据表
\d 表名 列出数据表的结构
create database chengyao; 创建数据库
drop database chengyao;删除数据库
psql -h localhost -p 5432 -U cheng postgres登录
select pg_roles.rolname from pg_roles; 查看角色
grant role_name to username; 赋予角色
修改一个字段为非null ： alter table users alter username set not null;

<!-- more -->

\x切换到竖排显示
select * from ps_proc;查询存储过程


一、建立数据库连接
----------------
接入PostgreSQL数据库: psql -h IP地址 -p 端口 -U 数据库名

之后会要求输入数据库密码

 

二、访问数据库

1、列举数据库：\l
2、选择数据库：\c 数据库名
3、查看该某个库中的所有表：\dt
4、切换数据库：\c interface
5、查看某个库中的某个表结构：\d 表名
6、查看某个库中某个表的记录：select * from apps limit 1;
7、显示字符集：\encoding
8、退出psgl：\q

 

==================================================================================

列出当前数据库所有表
\dt

列出表名
SELECT tablename FROM pg_tables;
WHERE tablename NOT LIKE 'pg%'
AND tablename NOT LIKE 'sql_%'
ORDER BY tablename;

列出数据库名
\l
或
SELECT datname FROM pg_database;

切换数据库
\c 数据库名

1、通过命令行查询
\d 数据库 —— 得到所有表的名字
\d 表名 —— 得到表结构
2、通过SQL语句查询
"select * from pg_tables" —— 得到当前db中所有表的信息（这里pg_tables是系统视图）
"select tablename from pg_tables where schemaname='public'" —— 得到所有用户自定义表的名字（这里"tablename"字段是表的名字，"schemaname"是schema的名字。用户自定义的表，如果未经特殊处理，默认都是放在名为public的schema下）

 View Code
 

==================================================================================

postgresql数据管理系统使用命令方式有两种:
1. 内部命令,以反斜线开始 \ ,如: \l 显示所有数据库
2. 标准SQL命令,以分号 ; 或 \g 结束,可以使用多行

数据库的关键操作:
1. 启动服务  2. 登录  3. 建立数据库  4. 建立表  5. 插入记录到表中 
6. 更新/删除/查询/修改操作           7. 退出    8. 停止服务

在windows7中安装的postgresql默认使用GBK字符集,经常不能使用显示中文的数据表,解决办法:
注意:在windows 7下的postgresql中写操作时要使用GBK,读操作时要用UTF8;

设置字符集为 utf-8 就可以了.
postgres=# \encoding utf-8       // 设置客户端的字元集
postgres=# \encoding                  // 显示客户端的字元集
postgres=# show client_encoding;      // 显示客户端的字元集
postgres=# show server_encoding;      // 显示服务器的字元集

启动服务:
net start postgresql-9.5
停止服务:
net stop postgresql-9.5

获取命令帮助:
c:\> psql --help

登录( 注意: postgres 是默认用户即管理员 ):
路径 psql -h 服务器 -U 用户名  -d 数据库 -p 端口地址  // -U 是大写
C:\> psql -h localhost -U postgres -p 5432            // 默认打开postgres数据库
C:\> psql -h 127.0.0.1 -U postgres -d fengdos -p 5432 // 打开fengdos数据库
C:\> psql -U postgres                                 // 快速登录(全部使用默认设置)
// 使用某些有密码的用户的情况下, 会提示输入密码.
用户 postgres 的口令: ILoveYou         // 输入时不会显示任何字符
// 成功后显示:
psql (9.5.3)
输入 "help" 来获取帮助信息.
// 进入postgresql数据库系统提示符状态, ******=# 中=#前面为当前使用的数据库
postgres=# help          // 获取系统帮助,显示如下:
---------------------------------------------------------
您正在使用psql, 这是一种用于访问PostgreSQL的命令行界面
键入：\copyright 显示发行条款
      \h 显示 SQL 命令的说明
      \? 显示 pgsql 命令的说明 (pgsql内部命令)
      \g 或者以分号(;)结尾以执行查询
      \q 退出注: 数据库名称区分大小写的。
---------------------------------------------------------
postgres=# \help         // 获取SQL命令的帮助,同 \h
postgres=# \quit         // 退出,同 \q
postgres=# \password dlf // 重新设置用户dlf的密码,然后需要 \q退出后才生效
c:\>psql exampledb < user.sql  // 将user.sql文件导入到exampled数据库中
postgres=# \h select   // 精细显示SQL命令中的select命令的使用方法
postgres=# \l          // 显示所有数据库
postgres=# \dt         // 显示当前数据库中的所有表
postgres=# \d [table_name]  // 显示当前数据库的指定表的表结构
postgres=# \c [database_name]  // 切换到指定数据库,相当于use
postgres=# \du                 // 显示所有用户
postgres=# \conninfo           // 显示当前数据库和连接信息
postgres=# \e   // 进入记事本sql脚本编辑状态(输入批命令后关闭将自动在命令行中执行)
postgres=# \di  // 查看索引(要建立关联)
postgres=# \prompt [文本] 名称    // 提示用户设定内部变数
postgres=# \encoding [字元编码名称]  // 显示或设定用户端字元编码
*可以将存储过程写在文本文件中aaa.sql,然后在psql状态下:
postgres=# \i aaa.sql    // 将aaa.sql导入(到当前数据库)
postgres=# \df           // 查看所有存储过程（函数）
postgres=# \df+ name     // 查看某一存储过程
postgres=# select version();            // 获取版本信息
postgres=# select usename from pg_user; // 获取系统用户信息
postgres=# drop User 用户名             // 删除用户

其它SQL命令通用如(标准化SQL语句):
*创建数据库：
create database [数据库名];

*删除数据库：
drop database [数据库名]; 

*创建表：
create table ([字段名1] [类型1] ;,[字段名2] [类型2],......<,primary key (字段名m,字段名n,...)>;);

*在表中插入数据：
insert into 表名 ([字段名m],[字段名n],......) values ([列m的值],[列n的值],......);

*显示表内容:
select * from student;

*重命名一个表：
alter table [表名A] rename to [表名B];

*删除一个表：
drop table [表名]; 

*在已有的表里添加字段：
alter table [表名] add column [字段名] [类型];

*删除表中的字段：
alter table [表名] drop column [字段名];

*重命名一个字段： 
alter table [表名] rename column [字段名A] to [字段名B];

*给一个字段设置缺省值： 
alter table [表名] alter column [字段名] set default [新的默认值];

*去除缺省值： 
alter table [表名] alter column [字段名] drop default;
 
*修改表中的某行某列的数据：
update [表名] set [目标字段名]=[目标值] where [该行特征];

*删除表中某行数据：
delete from [表名] where [该行特征];
delete from [表名];    // 删空整个表

*可以使用pg_dump和pg_dumpall来完成。比如备份sales数据库：
pg_dump drupal>/opt/Postgresql/backup/1.bak


===================================================================================================

1.列出所有表名的查询语句
SELECT tablename FROM pg_tables
WHERE tablename NOT LIKE 'pg%'
AND tablename NOT LIKE 'sql_%'
ORDER BY tablename;

2.列出表中所有的数据

SELECT * FROM someTable;

3.执行外部脚本
#/opt/PostgreSQL/8. 3/bin/psql - Upostgres ;登陆到数据库的控制台界面
postgres= # \i /root/db. sql
     \i 命令用于执行一个外部的sql脚本文件。

 
4.导出数据库为外部的脚本
#/opt/PostgreSQL/8. 3/bin/ pg_dump - Upostgres - C - fdb. sql database

-C create    -f 是导出后的文件名

 

5.postgresql 插入16进制数 
INSERT INTO tableAAA VALUES( x'0001f' : : integer, '鉴权' , 'Authority' )

6.使用 TG_RELNAME 报错ERROR:  syntax error at or near "$1" at character

[引]http://www.dbmonster.com/Uwe/Forum.aspx/postgresql/2051/TG-RELNAME-problem

Perhaps you will get some idea if you read the document:
37. 6. 4. Executing Dynamic Commands

改：执行动态语句

 EXECUTE 'INSERT INTO TG_RELNAME VALUES (NEW.start_time , NEW.id , NEW.end_time)';

 
7. psql 常用命令
a. \c tesdb1 - - 将当前连接的testdb数据库改变成 testdb1 。
b . \q - - 断开与Postgres服务器的连接
c . \l 列出所有数据库的名字
    \l+ 列出所有数据库的名字以及字符集编码
d. \d [ 名字] 描述表, 索引, 序列, 或者视图
                 列出表/索引/序列/视图/系统表
   \d{t| i| s| v| S} [ 模式] ( 加 "+" 获取更多信息)
                 - - 列出表/索引/序列/视图/系统表
   \d tablename - - 查看表的结构
   \dt - - 列出数据库中所有表

8.在PostgreSQL中如何删除重复记录

【转】http: / / hi. baidu. com/cicon/blog/item/e14f217f4eeee20429388a0c. html

在PostgreSQL中删除重复记录其实很简单，不论有多少行重复，只要在要删除重复记录的表中table加一列rownum字段( id为table表中的主键) ，类型设置为serial类型即可，然后执行sql
delete from deltest where rownum not in(
select max(rownum) from deltest
);
最后删除列rownum即可

 

==============================================

正文：

连接数据库操作：

psql是postgresql数据库提供的连接数据库shell命令，格式 psql 【option】 dbname

在终端输入psql 会使用默认的方式连接本地数据库，使用的用户名是登陆linux系统使用的用户名，

psql -U username -W pass 以及psql -U username -W pass databasenaem都可以实现连接数据库的功能，第一种方式是使用用户名username密码pass连接默认数据库（具体链接那个数据库还没搞清 楚），第二种方式使用用户名username密码pass连接username数据库。如果登录成功之后将显示类似信息

Welcome to psql 8.0.6, the PostgreSQL interactive terminal.

Type:  \copyright for distribution terms
       \h for help with SQL commands
       \? for help with psql commands
       \g or terminate with semicolon to execute query
       \q to quit

连接成功之后所有的命令都是使用”\“+ 字符或者word完成相应的功能。现将常用的几个列车

\l      列出所有数据库

\dt   列出连接数据库中所有表

\di   列出连接数据库中所有index

\dv  列出连接数据库中所有view

\h    sql命令帮助

\?    \ 所有命令帮助

\q   退出连接

\d tablename  列出指定tablename的表结构

可以尝试执行下面两句sql

SELECT current_date

SELECT version()

是不是nothing happened，这是因为postgresql数据库要求必须使用；结尾否则不予执行，加上；之后就能看到结果了。

如果我们想创建数据库怎么办呢？

我们知道createdb和dropdb可以创建和删除数据库，但是如果我们这个时候执行出现什么问题呢？可以试一试，提示是个错误。

为什么呢？

createdb和dropdb是shell脚本，所以现在又两种方式执行

（1）.退出连接进入终端，输入createdb test —U user -W pass 稍等提示创建数据库成功

```
dropdb test —U user -W pass    提示drop成功
```


（2）.在未退出连接中使用 \! createdb test —U user -W pass 稍等提示创建数据库成功

```
\! dropdb test —U user -W pass  提示drop成功
```