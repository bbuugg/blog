---
title: Systemctl和service、chkconfig命令的关系
date: 2021-05-01 21:31:09
tags:
---

# systemctl
> systemctl命令：是一个systemd工具，主要负责控制systemd系统和服务管理器。

<!-- more -->

```
systemctl list-units
systemctl start firewalld systemctl restart firewalld
systemctl stop fitrwalld
systemctl disable firewalld
systemctl enable firewalld
systemctl is-active firewall
systemctl is-enabled firewalldsystemctl status firewalld
```
# service
>service命令：可以启动、停止、重新启动和关闭系统服务，还可以显示所有系统服务的当前状态。

```
  service network restart/start/stop
  service network status
  service --status-all [补充]
```

# chkconfig
>chkconfig命令：是管理系统服务(service)的命令行工具。所谓系统服务(service)，就是随系统启动而启动，随系统关闭而关闭的程序。

```
chkconfig ntpd on/off/reset(永久关闭某个服务)

chkconfig list
```

systemctl命令是系统服务管理器指令，它实际上将 service 和 chkconfig 这两个命令组合到一起。
systemctl是RHEL 7 的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。可以使用它永久性或只在当前会话中启用/禁用服务。
所以systemctl命令是service命令和chkconfig命令的集合和代替。

  
来源：https://www.cnblogs.com/hx1998/p/10923993.html [有补充]