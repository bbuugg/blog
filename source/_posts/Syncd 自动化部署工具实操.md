---
title: Syncd 自动化部署工具实操
date: 2021-10-30 12:11:12
tags:
---

# 写在前面

syncd是一款开源的代码部署工具，它具有简单、高效、易用等特点，可以提高团队的工作效率.

gitee : https://gitee.com/dreamans/syncd

# 简单上手

## 部署

可以使用官方提供的脚本安装

```
curl https://syncd.cc/install.sh | bash
```

因为脚本使用了github的仓库，如果很慢可以下载脚本后更改成gitee的地址再安装，也可以直接下载源码，执行make命令安装，前提是你要有go的环境。

因为编译时间较长，所以我直接
```
make & 
```
你也可以用`nohup`

让他在后台编译了，编译成功之后会出现一个`syncd-deploy` 的目录，如果你要记录编译日志可以自行添加

要做的有两步 
1. 修改配置文件`/syncd-deploy/etc/syncd.ini`, 更改数据库连接配置
2. 导入数据，如果出现`database exists` 可以编辑下 `/syncd-deploy/resource/sql/syncd_v2.0.0.sql` ,把 `create database syncd default charset utf8mb4;` 改成 `create database if not exists syncd default charset utf8mb4;`
使用官方的命令导入数据, 例如
```
mysql -usyncd -p --default-character-set=utf8mb4 < /test.sql
```

可以根据需要修改`syncd`监听的端口

## 运行

执行
```
/syncd-deploy/bin/syncd
```
打开ip + 端口, 默认用户名：syncd, 密码：111111

## 配置

### 新建集群

![](/upload/images/20211030/600575a7cd85f74b3e303fd4c3dbc30d.png)

### 新建服务器

![](/upload/images/20211030/8233db934280e5c271630600bfdcd307.png)

注意，这里新建的服务器必须是当前服务器可免密登录的，所以可以根据这篇文档实现使用ssh key 登录 https://www.chengyao.xyz/note/188.html

### 空间管理

![](/upload/images/20211030/f8cb6ff28075a4ae73992e772376d83f.png)

### 项目管理

![](/upload/images/20211030/63181feaa3de97eb172890cc801a40d9.png)

### 提交上线单

![](/upload/images/20211030/62e574538f7fd9367eb96ac68ed20de9.png)

### 上线

![](/upload/images/20211030/20f1671106e12ad56a69877308a89c85.png)

先构建，再部署

![](/upload/images/20211030/c1212e444c403b3a3567d3acfa1cbe33.png)

### 部署成功

![](/upload/images/20211030/3fe2340146764762fa6e9e7578e2aa7e.png)

### hook

如果你的项目需要构建或部署完成之后执行一些操作，可以按照下图步骤配置
![](/upload/images/20211030/5f30b29c59cdf87f93f229071f40a265.png)

## 监控进程

可以参考笔记： https://www.chengyao.xyz/note/234.html