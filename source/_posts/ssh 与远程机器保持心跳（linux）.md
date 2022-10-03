---
title: ssh 与远程机器保持心跳（linux）
date: 2021-05-03 14:42:35
tags:
---

在连接远程SSH服务的时候，经常会发生长时间后的断线，或者无响应（无法再键盘输入）。

<!-- more -->


总体来说有两个方法：
一、客户端定时发送心跳
1.putty、SecureCRT、XShell都有这个功能，设置请自行搜索

2.此外在Linux下：

#修改本机/etc/ssh/ssh_config
vim /etc/ssh/ssh_config
# 添加
```
ServerAliveInterval 30
ServerAliveCountMax 100
```
即每隔30秒，向服务器发出一次心跳。若超过100次请求，都没有发送成功，则会主动断开与服务器端的连接。

 

二、服务器端定时向客户端发送心跳（一劳永逸）

# 修改服务器端 ssh配置 /etc/ssh/sshd_config

vim /etc/ssh/sshd_config
# 添加
```
ClientAliveInterval 30
ClientAliveCountMax 6
```
ClientAliveInterval表示每隔多少秒，服务器端向客户端发送心跳，是的，你没看错。

下面的ClientAliveInterval表示上述多少次心跳无响应之后，会认为Client已经断开。

所以，总共允许无响应的时间是60*3=180秒。