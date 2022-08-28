---
title: 如何使用Telnet
date: 2021-11-21 15:07:42
tags:
---

> 退出telnet使用ctrl + ] 再 ctrl + d

# 发送HTTP请求

## 打开连接

```
telnet chengyao.xyz 80
```

## 发送数据

```
GET / HTTP/1.1
Host: localhost
\r\n
```

> 这里的Host是必须的，否则会400

发送`Content-Length` 头后服务端会等待输入相应长度的内容后才返回
`POST` 提交的时候需要添加`Content-Type`

## 结果
```
cheng@DESKTOP-845LJ9G:/mnt/c/Users/ChengYao$ telnet chengyao.xyz 80
Trying 1.14.70.42...
Connected to chengyao.xyz.
Escape character is '^]'.
GET / HTTP/1.1
Host: localhost

HTTP/1.1 200 OK
Server: nginx
Date: Sun, 21 Nov 2021 07:04:56 GMT
Content-Type: text/html
Content-Length: 1326
Last-Modified: Wed, 26 Apr 2017 08:03:47 GMT
Connection: keep-alive
Vary: Accept-Encoding
ETag: "59005463-52e"
Accept-Ranges: bytes

<!doctype html>
<html>
<head>
<meta charset="utf-8">
```

## 其他

请求头
```
If-Modified-Since
If-None-Mathch
````

服务端响应
```
ETag
```

如果客户端没有过期，服务端不在发送，返回304，而是从本地取

使用307重定向可以保持数据，例如post提交到a.php， a.php重定向到b.php，则可以用307重定向

# 连接SMTP服务器

```shell
telnet smtp.qq.com 25
Trying 14.18.175.202...
Connected to smtp.qq.com.
Escape character is '^]'.
220 newxmesmtplogicsvrsza9.qq.com XMail Esmtp QQ Mail Server.
HELO localhost
250-newxmesmtplogicsvrsza5.qq.com-9.22.14.83-79972670
250-SIZE 73400320
250 OK
AUTH LOGIN
334 VXNlcm5hbWU6
OTg3ODYxNDY4QHFxLmNvb1==
334 UGFzc3dvcmQ6
Y2xqYXB5aWJlRTd1mRiaA==
235 Authentication successful
MAIL FROM: <987861463@qq.com>
250 OK
RCPT TO: <bigyao@139.com>
250 OK
DATA
354 End data with <CR><LF>.<CR><LF>.
Dear, hello, thank you.
.
250 OK: queued as.
```
