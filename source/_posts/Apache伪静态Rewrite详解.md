---
title: Apache伪静态Rewrite详解
date: 2020-11-18 22:16:19
tags:
---

# 一、Rewrite规则简介：
Rewirte主要的功能就是实现URL的跳转，它的正则表达式是基于 Perl语言。可基于服务器级的(httpd.conf)和目录级的 (.htaccess)两种方式。如果要想用到rewrite模块，必须先安装或加载rewrite模块。方法有两种一种是编译apache的时候就直接 安装rewrite模块，别一种是编译apache时以DSO模式安装apache,然后再利用源码和apxs来安装rewrite模块。

<!-- more -->

# 二、在Apache配置中启用Rewrite
打开配置文件httpd.conf：

复制代码 代码如下:

1.启用rewrite
\# LoadModule rewrite_module modules/mod_rewrite.so 去除前面的 #
2.启用.htaccess
在虚拟机配置项中
AllowOverride None    修改为： AllowOverride All


# 三、Rewrite基本写法
服务器有配置文件不可能由我们来改，所以大多情况下要在网站的根目录下建一个.htaccess文件。

复制代码 代码如下:

RewriteEngine on    //启动rewrite引擎
RewriteRule ^/index([0-9]*).html$ /index.php?id=$1   //“([0-9]*)” 代表范围 用(.*)代表所有，下同。
RewriteRule ^/index([0-9]*)/$ /index.php?id=$1 [R]   //虚拟目录

# 四、Apache mod_rewrite规则重写的标志一览
```
1) R[=code](force redirect) 强制外部重定向
强制在替代字符串加上http://thishost[:thisport]/前缀重定向到外部的URL.如果code不指定，将用缺省的302 HTTP状态码。
2) F(force URL to be forbidden)禁用URL,返回403HTTP状态码。
3) G(force URL to be gone) 强制URL为GONE，返回410HTTP状态码。
4) P(force proxy) 强制使用代理转发。
5) L(last rule) 表明当前规则是最后一条规则，停止分析以后规则的重写。
6) N(next round) 重新从第一条规则开始运行重写过程。
7) C(chained with next rule) 与下一条规则关联
如果规则匹配则正常处理，该标志无效，如果不匹配，那么下面所有关联的规则都跳过。
8) T=MIME-type(force MIME type) 强制MIME类型
9) NS (used only if no internal sub-request) 只用于不是内部子请求
10) NC(no case) 不区分大小写
11) QSA(query string append) 追加请求字符串
12) NE(no URI escaping of output) 不在输出转义特殊字符
例如：RewriteRule /foo/(.*) /bar?arg=P1%3d$1 [R,NE] 将能正确的将/foo/zoo转换成/bar?arg=P1=zoo
13) PT(pass through to next handler) 传递给下一个处理
	例如:
	RewriteRule ^/abc(.*) /def$1 [PT] # 将会交给/def规则处理
	Alias /def /ghi

14) S=num(skip next rule(s)) 跳过num条规则
15) E=VAR:VAL(set environment variable) 设置环境变量
```


# 五、Apache rewrite例子
## 例子一:
同时达到下面两个要求：
1.用http://www.jb51.net/xxx.php 来访问 http://www.jb51.net/xxx/
2.用http://yyy.jb51.net 来访问 http://www.jb51.net/user.php?username=yyy 的功能

代码如下:
```shell
RewriteEngine On
RewriteCond %{HTTP_HOST} ^www.jb51.net
RewriteCond %{REQUEST_URI} !^user.php$
RewriteCond %{QUERY_STRING} "!^page"
RewriteCond %{REQUEST_URI} .php$
RewriteRule (.*).php$ http://www.jb51.net/$1/ [R]
RewriteCond %{HTTP_HOST} !^www.jb51.net
RewriteRule ^(.+) %{HTTP_HOST} [C]
RewriteRule ^([^.]+).jb51.net http://www.jb51.net/user.php?username=$1
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
```
## 例子二：

代码如下:
```shell
/type.php?typeid=* –> /type*.html
/type.php?typeid=*&page=* –> /type*page*.html
RewriteRule ^/type([0-9]+).html$ /type.php?typeid=$1 [PT]
RewriteRule ^/type([0-9]+)page([0-9]+).html$ /type.php?typeid=$1&page=$2 [PT]
```