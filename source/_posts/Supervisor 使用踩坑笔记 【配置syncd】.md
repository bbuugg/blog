---
title: Supervisor 使用踩坑笔记 【配置syncd】
date: 2021-10-30 11:43:09
tags:
---

# 前言
> 之前有使用hyperf这样的框架开发过，但是线上部署没有实操，也不清楚进程监控怎么配置，所以学习了一下，记录一篇笔记。

我主要是看了这篇文章的讲解：https://www.1kmb.com/note/284.html
内容很不错，推荐在这里。

# 实操

根据教程配置了syncd的监控配置如下

```
[program:syncd]
directory=/root/syncd-deploy
command=/root/syncd-deploy/bin/syncd
autostart=true
autorestart=true
startsecs=1
;user=root
stderr_logfile=/data/logs/syncd.log
stdout_logfile=/data/logs/syncd.log
redirect_stderr=true
stdout_logfile_maxbytes=30MB
strout_logfile_backups=20
```

注意这个配置文件的后缀是ini，之前不小心建成conf文件，导致使用`supervisorctl start syncd` 的时候出现了下面的报错

> 更正：系统不同配置后缀不同

```
syncd: ERROR (no such process)
```

查看`/etc/supervisord.conf` 里面会有[include]一节，files就是其他进程的配置文件

更改后使用`supervisorctl update` 命令更新配置提示错误
```
error: <class 'xmlrpclib.Fault'>, <Fault 92: "CANT_REREAD: The directory named as part of the path /data/logs/syncd.log does not exist in section 'program:syncd' (file: '/etc/supervisord.d/syncd.ini')">: file: /usr/lib64/python2.7/xmlrpclib.py line: 794
```
原来是日志目录不存在，新建目录后再次执行提示
```
syncd: added process group
```

再次执行
```
supervisorctl start syncd
```
提示
```
syncd: ERROR (spawn error)
```

执行

```
supervisorctl status
```
提示

```
syncd                            FATAL     Exited too quickly (process log may have details)
```
查看日志
```
less /data/logs/syncd.log
```

一堆
```
/root/syncd-deploy/bin/syncd: /root/syncd-deploy/bin/syncd: cannot execute binary file
```

原来是因为之前启动不了。以为要加什么解释器，于是配置文件里面就出现了

```
command=bash /root/syncd-deploy/bin/syncd
```

但是这个syncd是go编译后的二进制文件，所以报错了。。。 在上面的配置中已经去掉了。

更改上面的bug后执行
```
supervisorctl update
```

提示

```
syncd: stopped
syncd: updated process group
```

查看下状态
```
[root@VM-0-10-centos ~]# supervisorctl status
syncd                            RUNNING   pid 20999, uptime 0:00:04
```

然后根据syncd配置的端口访问下，正常。

# 总结

配置文件不要搞错， 涉及日志目录的要确保目录存在，命令怎么执行要写完整。