---
title: Ubuntu的messages Log开启
date: 2021-04-21 22:49:08
tags:
---

# ubuntu开启messages log

```less /etc/rsyslog.d/50-default.conf ```

```
#*.=info;*.=notice;*.=warn;\
#       auth,authpriv.none;\
#       cron,daemon.none;\
#       mail,news.none          -/var/log/messages
```

删掉以上部分的注释，重启`rsyslog`

```
service rsyslog restart
```

# 使用以下命令查看`log`文件

```
tail -f /var/log/messages
```

```
tail -10 /var/log/messages
```