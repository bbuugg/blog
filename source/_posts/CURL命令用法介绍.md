---
title: CURL命令用法介绍
date: 2021-04-19 18:18:54
tags:
---

# 输出状态码

```
curl -I -m 10 -o /dev/null -s -w %{http_code} www.baidu.com
```

- -I 仅测试HTTP头
- -m 10 最多查询10s
- -o /dev/null 屏蔽原有输出信息
- -s silent 模式，不输出任何东西
- -w %{http_code} 控制额外输出

-w 参数如下

- url_effective 最终获取的url地址，尤其是当你指定给curl的地址存在301跳转，且通过-L继续追踪的情形。
- http_code http状态码，如200成功,301转向,404未找到,500服务器错误等。(The numerical response code that was found in the last retrieved HTTP(S) or FTP(s) transfer. In 7.18.2 the alias response_code was added to show the same info.)
- http_connect The numerical code that was found in the last response (from a proxy) to a curl CONNECT request. (Added in 7.12.4)
- time_total 总时间，按秒计。精确到小数点后三位。 （The total time, in seconds, that the full operation lasted. The time will be displayed with millisecond resolution.）
- time_namelookup DNS解析时间,从请求开始到DNS解析完毕所用时间。(The time, in seconds, it took from the start until the name resolving was completed.)
- time_connect 连接时间,从开始到建立TCP连接完成所用时间,包括前边DNS解析时间，如果需要单纯的得到连接时间，用这个time_connect时间减去前边time_namelookup时间。以下同理，不再赘述。(The time, in seconds, it took from the start until the TCP connect to the remote host (or proxy) was completed.)
- time_appconnect 连接建立完成时间，如SSL/SSH等建立连接或者完成三次握手时间。(The time, in seconds, it took from the start until the SSL/SSH/etc connect/handshake to the remote host was completed. (Added in 7.19.0))
- time_pretransfer 从开始到准备传输的时间。(The time, in seconds, it took from the start until the file transfer was just about to begin. This includes all pre-transfer commands and negotiations that are specific to the particular protocol(s) involved.)
- time_redirect 重定向时间，包括到最后一次传输前的几次重定向的DNS解析，连接，预传输，传输时间。(The time, in seconds, it took for all redirection steps include name lookup, connect, pretransfer and transfer before the final transaction was started. time_redirect shows the complete execution time for multiple redirections. (Added in 7.12.3))
- time_starttransfer 开始传输时间。在发出请求之后，Web 服务器返回数据的第一个字节所用的时间(The time, in seconds, it took from the start until the first byte was just about to be transferred. This includes time_pretransfer and also the time the server needed to calculate the result.)
- size_download 下载大小。(The total amount of bytes that were downloaded.)
- size_upload 上传大小。(The total amount of bytes that were uploaded.)
- size_header 下载的header的大小(The total amount of bytes of the downloaded headers.)
- size_request 请求的大小。(The total amount of bytes that were sent in the HTTP request.)
- speed_download 下载速度，单位-字节每秒。(The average download speed that curl measured for the complete download. Bytes per second.)
- speed_upload 上传速度,单位-字节每秒。(The average upload speed that curl measured for the complete upload. Bytes per second.)
- content_type 就是content-Type，不用多说了，这是一个访问我博客首页返回的结果示例(text/html; charset=UTF-8)；(The Content-Type of the requested document, if there was any.)
- num_connects 最近的的一次传输中创建的连接数目。Number of new connects made in the recent transfer. (Added in 7.12.3)
- num_redirects 在请求中跳转的次数。Number of redirects that were followed in the request. (Added in 7.12.3)
- redirect_url When a HTTP request was made without -L to follow redirects, this variable will show the actual URL a redirect would take you to. (Added in 7.18.2)
- ftp_entry_path 当连接到远程的ftp服务器时的初始路径。The initial path libcurl ended up in when logging on to the remote FTP server. (Added in 7.15.4)
- ssl_verify_result ssl认证结果，返回0表示认证成功。( The result of the SSL peer certificate verification that was requested. 0 means the verification was successful. (Added in 7.19.0))

## 使用案例

以下是使用curl诊断服务器到微信api服务器的网络访问情况
```shell
curl -o /dev/null -s -w "time_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_nslookup:%{time_namelookup}\ntime_total: %{time_total}\n" "https://api.weixin.qq.com"
```

结果如下：
```shell
time_connect: 0.154
time_starttransfer: 0.243
time_nslookup:0.150
time_total: 0.243
```
说明: 以上显示网络连接时间为0.154秒（其中DNS解析为0.150秒），总体请求0.243秒。DNS解析出现故障的概率在正式环境中比较高，所以在诊断时候千万别漏了time_namelookup这个参数。

参考：
https://curl.haxx.se/docs/manpage.html
http://digdeeply.org/archives/05102012.html