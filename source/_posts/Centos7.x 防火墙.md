---
title: Centos7.x 防火墙
date: 2021-11-14 22:34:17
cover: /images/20221002/7757f363fe2a7e6bae816004e1203bee.jpg
tags:
---

> CentOS 7.x 默认使用的是firewall作为防火墙，取代6.x的iptables

#### 1. 查看防火墙状态

------

**命令如下**

```
firewall-cmd --state
```

<!-- more -->

该命令有两种结果：`running`、`not running`；前者代表是`开启状态`，后者代表是`关闭状态`

在 vmware 上安装的centos7最小化镜像防火墙默认是开机自启的

[![img](https://img.itqaq.com/art/content/028e377d019bac9774c07fecd426191f.png)](https://img.itqaq.com/art/content/028e377d019bac9774c07fecd426191f.png)

#### 2. 修改防火墙状态的相关命令（后缀 .service 可以省略）

------

**开启防火墙**

```
systemctl start firewalld.service
```

**关闭防火墙**

```
systemctl stop firewalld.service
```

**防火墙开机自启**

```
systemctl enable firewalld.service
```

**重启防火墙**

```
systemctl restart firewalld.service
```

**禁止防火墙开机自启**

```
systemctl disable firewalld.service
```

#### 3. 测试以上命令时可能会用到关机重启命令，在此也写下吧

------

**重启**

```
reboot
```

**关机（其实有很多方式，这里只写一种）**

```
init 0
```

文章来源：http://www.itqaq.com/index/art/126.html