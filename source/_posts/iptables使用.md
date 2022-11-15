---
title: iptables使用
toc: true
date: 2022-11-15 14:16:51
tags:
---

# ubuntu系统

ubuntu默认没有安装iptables，需要手动安装 apt-get install iptables, 默认没有配置文件，需要通过iptables-save > /etc/network/iptables.up.rules 来生成，iptables配置文件路径及文件名建议为/etc/network/iptables.up.rules,因为执行iptables-apply默认指向该文件，也可以通过-w参数指定文件，Ubuntu 没有重启iptables的命令，执行iptables-apply生效

常用命令

```
iptables-restore < /etc/network/iptables.up.rules 导入
iptables -nL --line-number  列表
iptables -A INPUT -p tcp --dport 22 -j ACCEPT 添加

```

注：允许策略一定要写到拒绝的上面，否则没用

https://blog.csdn.net/daocaokafei/article/details/115091313