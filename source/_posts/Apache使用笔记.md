---
title: apache使用笔记
date: 2021-05-18 10:48:32
tags:
toc: true
---

# 开启模块

加载SSL模块
sudo a2enmod ssl

sudo a2enmod http_proxy
sudo a2enmod proxy

# CGI简单配置


## 一， CGI简介

公共网关接口（Common Gateway Interface，CGI）是Web 服务器运行时外部程序的规范，按CGI 编写的程序可以扩展服务器功能。CGI 应用程序能与浏览器进行交互，还可通过数据API与数据库服务器等外部数据源进行通信，从数据库服务器中获取数据。格式化为HTML文档后，发送给浏览器，也可以将从浏览器获得的数据放到数据库中。几乎所有服务器都支持CGI，可用任何语言编写CGI，包括流行的Python、C、C ++、Java、VB 和Delphi 等。

<!-- more -->

## 二，CGI 配置

Apache2 中CGI的配置文件位于 /etc/apache2/mods-available/ 中（mods-enabled “ 为常用的（也就是默认开启的）， ” mods-available “为不常用的（也就是默认不开启)）。我们只需要将mods-available文件夹中的  " cgid.conf ", " cgid.load ", " cgi.load "  软连接到mods-enabled 文件夹就可以了

    sudo ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/cgid.conf
    sudo  ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/cgid.load
    sudo  ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

修改cgi.load的内容如下（vim /etc/apache2/mods-available/cgid.load ）：

```shell
LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so     //默认有则不需要加
AddHandler cgi-script .cgi .pl .py .sh       // 我们加入这一句，使CGI支持 perl和python 和shell脚本
```

## 三，修改默认的cgi-bin的路径
> vim /etc/apache2/conf-available/serve-cgi-bin.conf

```php
<IfModule mod_alias.c>
    <IfModule mod_cgi.c>
        Define ENABLE_USR_LIB_CGI_BIN
    </IfModule>
    <IfModule mod_cgid.c>
        Define ENABLE_USR_LIB_CGI_BIN
    </IfModule>
    <IfDefine ENABLE_USR_LIB_CGI_BIN>
        ScriptAlias /cgi-bin/ /var/www/cgi-bin/
            <Directory "/var/www/cgi-bin">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch Require all granted
            </Directory>
    </IfDefine>
</IfModule>
```
## 四，重启Apache2 服务
```shell
sudo service apache2 restart
```

> 参考：http://httpd.apache.org/docs/2.4/howto/cgi.html


# substitute模块

apache 的 
```
<location>
</location>
```

```
Substitute https://httpd.apache.org/docs/2.4/mod/mod_substitute.html
RewriteCond
```

开启substitute 需要加载substitute和filter模块,添加
```
AddOutputFilterByType SUBSTITUTE
text/html
Substitute s///[iqnf]
```

<!-- more -->

```
Substitute "s|((?:\<\s*/body\s*\>\s*)\z)|\
     <script type=\"text/javascript\">\
       (function () {\
         var tagjs = document.createElement(\"script\");\
         var s = document.getElementsByTagName(\"script\")[0];\
         tagjs.async = true;\
         tagjs.src = \"//s.tag.cn/tag.js#site=1234\";\
         s.parentNode.insertBefore(tagjs, s);\
       }());\
     </script>\
     <noscript>\
       <iframe src=\"//b.tag.cn/iframe?c=1234\" width=\"1\" height=\"1\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\">\
     </iframe>\
     </noscript>\
     </script>\
     </body>\
```

# 伪静态Rewrite详解

## 一、Rewrite规则简介：
Rewirte主要的功能就是实现URL的跳转，它的正则表达式是基于 Perl语言。可基于服务器级的(httpd.conf)和目录级的 (.htaccess)两种方式。如果要想用到rewrite模块，必须先安装或加载rewrite模块。方法有两种一种是编译apache的时候就直接 安装rewrite模块，别一种是编译apache时以DSO模式安装apache,然后再利用源码和apxs来安装rewrite模块。

<!-- more -->

## 二、在Apache配置中启用Rewrite
打开配置文件httpd.conf：

复制代码 代码如下:

1.启用rewrite
\# LoadModule rewrite_module modules/mod_rewrite.so 去除前面的 #
2.启用.htaccess
在虚拟机配置项中
AllowOverride None    修改为： AllowOverride All


## 三、Rewrite基本写法
服务器有配置文件不可能由我们来改，所以大多情况下要在网站的根目录下建一个.htaccess文件。

复制代码 代码如下:

RewriteEngine on    //启动rewrite引擎
RewriteRule ^/index([0-9]*).html$ /index.php?id=$1   //“([0-9]*)” 代表范围 用(.*)代表所有，下同。
RewriteRule ^/index([0-9]*)/$ /index.php?id=$1 [R]   //虚拟目录

## 四、Apache mod_rewrite规则重写的标志一览
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


## 五、Apache rewrite例子
### 例子一:
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
### 例子二：

代码如下:
```shell
/type.php?typeid=* –> /type*.html
/type.php?typeid=*&page=* –> /type*page*.html
RewriteRule ^/type([0-9]+).html$ /type.php?typeid=$1 [PT]
RewriteRule ^/type([0-9]+)page([0-9]+).html$ /type.php?typeid=$1&page=$2 [PT]
```