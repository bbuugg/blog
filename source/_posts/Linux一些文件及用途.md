---
title: Linux一些文件及用途
date: 2021-12-07 22:17:18
tags:
---

# 常用文件
## /etc/sysconfig/network-scripts/ifcfg-eth0 各参数的意思

```
DEVICE=eth0     #网卡设备名称

ONBOOT=yes      #启动时是否激活 yes | no

BOOTPROTO=static        #协议类型

IPADDR=192.168.1.90     #网络IP地址

NETMASK=255.255.255.0       #网络子网地址

GATEWAY=192.168.1.1     #网关地址

BROADCAST=192.168.1.255     #广播地址

HWADDR=00:0C:29:FE:1A:09        #网卡MAC地址

TYPE=Ethernet       #网卡类型为以太网
```

## /etc/sysconfig/i18n

i18n是internationalization的缩写，意思指i和n之间有18个字母。/etc/sysconfig/i18n里面存放着系统的区域语言设置，可以使linux系统支持国际化信息显示。就是支持多种字符集的转换，避免出现乱码。同一时间i18n只能是英文和一种选定的语言，例如英文+中文、英文+德文、英文+韩文等等。
使用locale [-a]查看系统当前locale环境变量

```
/etc/sysconfig/i18n 这里存放的是系统的区域语言设置
第一行 表明你当前系统的语言环境变量设置 ，这里是 zh_CN.GB18030
第二行 表明系统预置了那些语言支持 ，不在项目中的语言不能正常显示
第三行 定义控制台终端字体，你文本登录的时候显示的字体就是这个 latarcyrheb-sun16
```

```
[root@localhost chengyao]# locale  
LANG=zh_CN.GB18030  
LC_CTYPE="zh_CN.GB18030"  
LC_NUMERIC="zh_CN.GB18030"  
LC_TIME="zh_CN.GB18030"  
LC_COLLATE="zh_CN.GB18030"  
LC_MONETARY="zh_CN.GB18030"  
LC_MESSAGES="zh_CN.GB18030"  
LC_PAPER="zh_CN.GB18030"  
LC_NAME="zh_CN.GB18030"  
LC_ADDRESS="zh_CN.GB18030"  
LC_TELEPHONE="zh_CN.GB18030"  
LC_MEASUREMENT="zh_CN.GB18030"  
LC_IDENTIFICATION="zh_CN.GB18030"  
LC_ALL=  
```

## /etc/inittab

https://blog.csdn.net/localhostcom/article/details/78057132

## netplan

https://www.jianshu.com/p/174656635e74

## 发行版本
```shell
cat /etc/os-release # systemd
```
比uname -a更全的信息