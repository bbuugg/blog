---
title: FastCGI
date: 2021-04-03 21:57:23
tags:
---

#什么是CGI

CGI全称"通用网关接口"（Common Gateway Interface），用于HTTP服务器与其它机器上的程序服务通信交流的一种工具，CGI程序须运行在网络服务器上。

<!-- more -->

传统CGI接口方式的主要缺点是性能较差，因为每次HTTP服务器遇到动态程序时都需要重启解析器来执行解析，然后结果被返回给HTTP服务器。这在处理高并发访问几乎是不可用的，因此就诞生了FastCGI。另外传统的CGI接口方式安全性也很差。

# 什么是FastCGI

FastCGI是一个可伸缩地、高速地在HTTP服务器和动态脚本语言间通信的接口（FastCGI接口在Linux下是socket（可以是文件socket，也可以是ip  socket）），主要优点是把动态语言和HTTP服务器分离开来。多数流行的HTTP服务器都支持FastCGI，包括Apache、Nginx和lightpd。

同时，FastCGI也被许多脚本语言所支持，比较流行的脚本语言之一为PHP。FastCGI接口方式采用C/S架构，可以将HTTP服务器和脚本解析服务器分开，同时在脚本解析服务器上启动一个或多个脚本解析守护进程。当HTTP服务器每次遇到动态程序时，可以将其直接交付给FastCGI进程执行，然后将得到的结构返回给浏览器。这种方式可以让HTTP服务器专一地处理静态请求或者将动态脚本服务器的结果返回给客户端，这在很大程度上提高了整个应用系统的性能。

FastCGI的重要特点：

- 1、FastCGI是HTTP服务器和动态脚本语言间通信的接口或者工具。
- 2、FastCGI优点是把动态语言解析和HTTP服务器分离开来。
- 3、Nginx、Apache、Lighttpd以及多数动态语言都支持FastCGI。
- 4、FastCGI接口方式采用C/S架构，分为客户端（HTTP服务器）和服务端（动态语言解析服务器）。
- 5、PHP动态语言服务端可以启动多个FastCGI的守护进程。
- 6、HTTP服务器通过FastCGI客户端和动态语言FastCGI服务端通信。

# Nginx FastCGI的运行原理

Nginx不支持对外部动态程序的直接调用或者解析，所有的外部程序（包括PHP）必须通过FastCGI接口来调用。FastCGI接口在Linux下是socket（可以是文件socket，也可以是ip  socket）。为了调用CGI程序，还需要一个FastCGI的wrapper，这个wrapper绑定在某个固定socket(套接字)上，如端口或者文件socket。当Nginx将CGI请求发送给这个socket的时候，通过FastCGI接口，wrapper接收到请求，然后派生出一个新的线程，这个线程调用解释器或者外部程序处理脚本并读取返回数据；接着，wrapper再将返回的数据通过FastCGI接口，沿着固定的socket传递给Nginx；最后，Nginx将返回的数据发送给客户端，这就是Nginx+FastCGI的整个运作过程。

![](/upload/9dbd80f8c27ed29c5f4a56bef49928df.jpg)

Nginx+FastCGI运作过程

FastCGI的主要优点是把动态语言和HTTP服务器分离开来，是Nginx专一处理静态请求和向后转发动态请求，而PHP/PHP-FPM服务器专一解析PHP动态请求。

# 附：

![](/upload/ebf1720484cb52564bc499a7d0927c29.jpg)

ngnix配置解释