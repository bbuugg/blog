---
title: WSL2 使用笔记
date: 2021-11-05 22:18:35
cover: /images/20221002/4ef60d7e7f9c9677fdff1d931d71e43b.jpg
tags:
---

# 安装

> 官方文档

https://docs.microsoft.com/zh-cn/windows/wsl/install-manual

https://docs.microsoft.com/zh-cn/windows/wsl/install

# 登录相关

## 停止wsl2
```shell
wsl --shutdown
```
> wsl切换用户需要输入密码

可以根据下面文档去掉密码：
https://www.1kmb.com/note/232.html

<!-- more -->

# 默认使用root用户

运行cmd/powershell, 运行下面的命令
```
ubuntu1804 config --default-user root
wsl --shutdown
ubuntu1804
```
如果你的发行版是其他版本，修改ubuntu1804 即可

# ip相关

WSL2 每次重启后ip会变，网上提供了响应教程可以固定，实际上使用localhost就可以。如果你的子系统安装了nginx，建立虚拟机，绑定域名后在windows的hosts中将域名指向127.0.0.1

# IO问题

wsl2 和 windows之间的io速度很慢，所以可以安装俩子系统发行版，一个使用wsl1， 一个使用wsl2

```shell
wsl --set-version Ubuntu-18.04 1   # 将Ubuntu-18.04设置为wsl1
```

```shell
wsl -l -v  # 查看所有版本
```

# windows访问wsl
在文件资源管理器输入
```
\\wsl$
```