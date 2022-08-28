---
title: Oracle
date: 2021-04-02 18:40:16
tags:
---

查询建表语句 ：select dbms_metadata.get_ddl('TABLE','name') from dual;

查看存储过程： select dbms_metadata.get_ddl('PROCEDURE','BSA_PROC_FTP_MGMT','CLARO') from dual;

#### trunc() 

下面日期操作有误，仅做参考

1.select trunc(sysdate) from dual --2013-01-06 今天的日期为2013-01-06
2.select trunc(sysdate, 'mm') from dual --2013-01-01 返回当月第一天.
3.select trunc(sysdate,'yy') from dual --2013-01-01 返回当年第一天
4.select trunc(sysdate,'dd') from dual --2013-01-06 返回当前年月日
5.select trunc(sysdate,'yyyy') from dual --2013-01-01 返回当年第一天
6.select trunc(sysdate,'d') from dual --2013-01-06 (星期天)返回当前星期的第一天
7.select trunc(sysdate, 'hh') from dual --2013-01-06 17:00:00 当前时间为17:35 
8.select trunc(sysdate, 'mi') from dual --2013-01-06 17:35:00 TRUNC()函数没有秒的精确

/*
TRUNC（number,num_digits） 
Number 需要截尾取整的数字。 
Num_digits 用于指定取整精度的数字。Num_digits 的默认值为 0。
TRUNC()函数截取时不进行四舍五入
*/
9.select trunc(123.458) from dual --123
10.select trunc(123.458,0) from dual --123
11.select trunc(123.458,1) from dual --123.4
12.select trunc(123.458,-1) from dual --120
13.select trunc(123.458,-4) from dual --0
14.select trunc(123.458,4) from dual --123.458
15.select trunc(123) from dual --123
16.select trunc(123,1) from dual --123
17.select trunc(123,-1) from dual --120


oracle数据库控制台的删除变成^H的解决办法

在linux服务器下登录oracle的控制台，如果输入错误，想用删除键删除时却不能删除，打出的是^H的字符。

用如下的命令可以使删除键生效：

$ stty erase ^H

恢复以前的设置的命令是：

$  stty erase ^？



select table_name from all_tables; 查看所有表

select table_name from user_tables; 查看用户表

desc table_name; 查看表结构

select * from table_name where rownum < 10; 查看前rownum 小于10的数据

ROWNUM是一个序列，bai是oracle数据库du从数据文件或缓冲区中读取数据的顺序。它取得第一条记录则rownum值为1，第二条为2，依次类推。ROWNUM是一个序列，是oracle数据库从数据文件或缓冲区中读取数据的顺序。它取得第一条记录则rownum值为1，第二条为2，依次类推。