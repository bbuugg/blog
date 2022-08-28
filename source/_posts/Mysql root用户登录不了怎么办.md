---
title: Mysql root用户登录不了怎么办
date: 2022-01-17 12:34:54
tags:
---

# normal

## 杀掉原来进行着的mysql：
```
rcmysqld stop
```
或者：
```
service mysqld stop
```
或者：
```
kill -TERM mysqld
```
## 以命令行参数启动mysql：
```
/usr/bin/mysqld --skip-grant-tables
//不需要密码
mysql 
```
## 修改管理员密码：
```sql
use mysql;
# update user set password=password('yournewpasswordhere') where user='root';
alter user 'root' identified by 'yournewpassword';
flush privileges;
exit;
```
## 杀死mysql，重启mysql


# Docker

拷贝mysql配置文件
文件在容器中路径

```
/etc/mysql/conf.d/docker.cnf
```


默认配置为：

```
[mysqld]
skip-host-cache
skip-name-resolve
```


添加配置skip-grant-tables后：

```
[mysqld]
skip-host-cache
skip-name-resolve
skip-grant-tables
```


注意，开启后会导致正常连接被拒绝。
挂载配置文件到容器内，容器内登陆mysqlmysql -uroot -p回车（安全模式）免密登陆。修改root用户密码：

```
alter user 'root'@'%' identified by '123456';
```

注释：%表示授权所有主机登陆，123456为修改后密码。注意，密码太简单是修改会失败，建议设置强密码。
如果无论如何都要使用弱密码，请先执行：

## 修改validate_password_policy参数的值

```
set global validate_password_policy=0;
#validate_password_length(密码长度)参数默认为8，修改为需要长度
set global validate_password_length=1;
```

