---
title: RabbitMQ安装
date: 2022-01-23 15:56:30
tags:
---

# Docker安装RabbitMQ

## 下载镜像

```shell
docker pull rabbitmq:management  #management标签的含义是下载的镜像包含manage模块。包含web管理页面。
```

## 安装

```
docker run -dit --name myrabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 15672:15672 -p 5672:5672 rabbitmq:management
```

` -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin`指定`manage`模块的用户名和密码，我执行完后是报错的，也可以完全省略参数。
如果不指定默认用户名密码，系统会有默认用户名密码：`guest ` `guest`
所以，可以用下面命令。

```shell
docker run -d --hostname my-rabbit --name rabbit -p 15672:15672 -p 5673:5672 rabbitmq:management
```

现在可以通过访问http://linuxip:15672，访问web界面，这里的用户名和密码默认都是guest。

## 如果访问失败，可能是没有开启manage模块。

通过`docker ps -a`查看部署的`mq`容器`id`，在通过 `docker exec -it 容器id /bin/bssh` 进入容器内部在
运行：`rabbitmq-plugins enable rabbitmq_management`，执行完毕后重新访问web界面即可。

原文地址：[docker安装rabbitmq - chenxizhaolu - 博客园 (cnblogs.com)](https://www.cnblogs.com/chenxizhaolu/p/15145488.html)

# Ubuntu18.04安装RabbitMQ

## 安装erlang

由于`rabbitMq`需要`erlang`语言的支持，在安装r`abbitMq`之前需要安装`erlang`

```
sudo apt-get install erlang-nox
```

## 安装Rabbitmq

更新源

```shell
sudo apt-get update
```

安装

```shell
sudo apt-get install rabbitmq-server
```

启动、停止、重启、状态`RabbitMQ`命令

```shell
sudo rabbitmq-server start 
sudo rabbitmq-server stop
sudo rabbitmq-server restart
sudo rabbitmqctl status
```

## 添加admin，并赋予administrator权限

添加admin用户，密码设置为admin。

```java
sudo rabbitmqctl add_user  admin  admin  
```

赋予权限

```java
sudo rabbitmqctl set_user_tags admin administrator 
```

赋予virtual host中所有资源的配置、写、读权限以便管理其中的资源

```java
sudo rabbitmqctl  set_permissions -p / admin '.*' '.*' '.*'
```

## Web管理器连接

浏览器访问[http://192.168.1.42:15672](http://192.168.3.45:15672/)

[![img](https://img-blog.csdn.net/20180610200515165)](https://img-blog.csdn.net/20180610200515165)

使用刚刚创建的admin就可以登录，密码也为admin

 原文地址：[Ubuntu18.04安装RabbitMQ - Ellisonzhang - 博客园 (cnblogs.com)](https://www.cnblogs.com/ellisonzhang/p/15102942.html)

