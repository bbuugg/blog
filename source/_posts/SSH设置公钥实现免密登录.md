---
title: SSH设置公钥实现免密登录
date: 2021-05-04 16:51:01
tags:
---

&gt; 前提准备： 机器A需要使用免密登录连接机器B。测试机器为笔记本一台【wsl2 ubuntu】， centos7.6一台

# 准备
## 步骤一、首先在机器A上执行下面的命令
```shell
ssh-keygen -t rsa
```
执行结果如下：
```shell
root@DESKTOP-1SDORV4:~/.ssh# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
/root/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:u5Su/vifiFGxYSj8B6+7kLBAgX1iPrSL0scpPK6E4JM root@DESKTOP-1SDORV4
The key&#039;s randomart image is:
+---[RSA 3072]----+
|.o               |
|. *..  .         |
| = +o o +        |
|. +  o + +       |
|o+.+ .. S        |
|*.Bo+. + o       |
|oE.+o o +        |
|. o  . B o .     |
|..   .B=*.o      |
+----[SHA256]-----+
root@DESKTOP-1SDORV4:~/.ssh#
```
然后会在当前用户家目录下的`.ssh`文件夹下生成一个`id_rsa.pub`的文件，执行下面的命令复制文本内容
```
cat id_rsa.pub
```

## 步骤二、登录机器B

进入用户家目录的`.ssh`目录，新建或者修改`authorized_keys` 文件，将准备中的`key` 粘贴进去，保存。

# 测试

```
root@DESKTOP-1SDORV4:~/.ssh# ssh user@chengyao.xyz
Last failed login: Tue May  4 16:46:04 CST 2021 from 175.190.126.17* on ssh:notty
There were 6 failed login attempts since the last successful login.
Last login: Tue May  4 16:40:39 2021 from 111.19.83.22*

Welcome to Alibaba Cloud Elastic Compute Service !

manpath: can&#039;t set the locale; make sure $LC_* and $LANG are correct
[user@iZ2zeir6up2905ofunx6tdZ ~]#
```

至此说明你的免密登录成功了。

# 常见问题

在查看网上相关资料的时候发现很多人出了一些莫名奇妙的问题，有的人给的解决方案是将`.ssh`目录的权限设置为`0700`,将下面的文件权限设置为`0600` ，大家遇到问题可以检查下是不是权限的问题。