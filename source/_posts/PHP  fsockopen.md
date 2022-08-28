---
title: PHP  fsockopen
date: 2021-11-21 15:39:06
tags:
---

```
fsockopen(
    string $hostname,
    int $port = -1,
    int &amp;$errno = ?,
    string &amp;$errstr = ?,
    float $timeout = ini_get(&quot;default_socket_timeout&quot;)
): resource
```

初始化一个套接字连接到指定主机（`hostname`）。

PHP支持以下的套接字传输器类型列表 [所支持的套接字传输器（Socket Transports）列表](https://www.php.net/manual/zh/transports.php)。也可以通过[stream_get_transports()](https://www.php.net/manual/zh/function.stream-get-transports.php)来获取套接字传输器支持类型。

默认情况下将以阻塞模式开启套接字连接。当然你可以通过[stream_set_blocking()](https://www.php.net/manual/zh/function.stream-set-blocking.php)将它转换到非阻塞模式。

[stream_socket_client()](https://www.php.net/manual/zh/function.stream-socket-client.php)与之非常相似，而且提供了更加丰富的参数设置，包括非阻塞模式和提供上下文的的设置。

### 参数[ ¶](https://www.php.net/manual/zh/function.fsockopen.php#refsect1-function.fsockopen-parameters)

- `hostname`

  如果安装了[OpenSSL](https://www.php.net/manual/zh/openssl.installation.php)，那么你也许应该在你的主机名地址前面添加访问协议`ssl://`或者是`tls://`，从而可以使用基于TCP/IP协议的SSL或者TLS的客户端连接到远程主机。

- `port`

  端口号。如果对该参数传一个-1，则表示不使用端口，例如`unix://`。

- `errno`

  如果传入了该参数，holds the system level error number that occurred in the system-level `connect()` call。如果`errno`的返回值为`0`，而且这个函数的返回值为**`false`**，那么这表明该错误发生在套接字连接（`connect()`）调用之前，导致连接失败的原因最大的可能是初始化套接字的时候发生了错误。

- `errstr`

  错误信息将以字符串的信息返回。

- `timeout`

  设置连接的时限，单位为秒。**注意**:注意：如果你要对建立在套接字基础上的读写操作设置操作时间设置连接时限，请使用[stream_set_timeout()](https://www.php.net/manual/zh/function.stream-set-timeout.php)，**fsockopen()**的连接时限（`timeout`）的参数仅仅在套接字连接的时候生效。

### 返回值[ ¶](https://www.php.net/manual/zh/function.fsockopen.php#refsect1-function.fsockopen-returnvalues)

**fsockopen()**将返回一个文件句柄，之后可以被其他文件类函数调用（例如：[fgets()](https://www.php.net/manual/zh/function.fgets.php)，[fgetss()](https://www.php.net/manual/zh/function.fgetss.php)，[fwrite()](https://www.php.net/manual/zh/function.fwrite.php)，[fclose()](https://www.php.net/manual/zh/function.fclose.php)还有[feof()](https://www.php.net/manual/zh/function.feof.php)）。如果调用失败，将返回**`false`**。

### 错误／异常[ ¶](https://www.php.net/manual/zh/function.fsockopen.php#refsect1-function.fsockopen-errors)

如果主机（`hostname`）不可访问，将会抛出一个警告级别（**`E_WARNING`**）的错误提示。


**示例 #1 \**fsockopen()\**的例子**

```
&lt;?php
$fp = fsockopen(&quot;www.example.com&quot;, 80, $errno, $errstr, 30);
if (!$fp) {
    echo &quot;$errstr ($errno)&lt;br /&gt;\n&quot;;
} else {
    $out = &quot;GET / HTTP/1.1\r\n&quot;;
    $out .= &quot;Host: www.example.com\r\n&quot;;
    $out .= &quot;Connection: Close\r\n\r\n&quot;;
    fwrite($fp, $out);
    while (!feof($fp)) {
        echo fgets($fp, 128);
    }
    fclose($fp);
}
?&gt;
```

**示例 #2 使用UDP连接**

下面这个例子展示了怎么样在自己的机器上通过UDP套接字连接（端口号13）来检索日期和时间。

```
&lt;?php
$fp = fsockopen(&quot;www.example.com&quot;, 80, $errno, $errstr, 30);
if (!$fp) {
    echo &quot;$errstr ($errno)&lt;br /&gt;\n&quot;;
} else {
    $out = &quot;GET / HTTP/1.1\r\n&quot;;
    $out .= &quot;Host: www.example.com\r\n&quot;;
    $out .= &quot;Connection: Close\r\n\r\n&quot;;
    fwrite($fp, $out);
    while (!feof($fp)) {
        echo fgets($fp, 128);
    }
    fclose($fp);
}
?&gt;
```

原文地址： https://www.php.net/manual/zh/function.fsockopen.php