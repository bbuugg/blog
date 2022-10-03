---
title: Apache2 CGI 简单配置
date: 2021-01-04 21:20:12
tags:
---

### 一， CGI简介

公共网关接口（Common Gateway Interface，CGI）是Web 服务器运行时外部程序的规范，按CGI 编写的程序可以扩展服务器功能。CGI 应用程序能与浏览器进行交互，还可通过数据API与数据库服务器等外部数据源进行通信，从数据库服务器中获取数据。格式化为HTML文档后，发送给浏览器，也可以将从浏览器获得的数据放到数据库中。几乎所有服务器都支持CGI，可用任何语言编写CGI，包括流行的Python、C、C ++、Java、VB 和Delphi 等。

<!-- more -->

### 二，CGI 配置

Apache2 中CGI的配置文件位于 /etc/apache2/mods-available/ 中（mods-enabled “ 为常用的（也就是默认开启的）， ” mods-available “为不常用的（也就是默认不开启)）。我们只需要将mods-available文件夹中的  " cgid.conf ", " cgid.load ", " cgi.load "  软连接到mods-enabled 文件夹就可以了

    sudo ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/cgid.conf
    sudo  ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/cgid.load
    sudo  ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

修改cgi.load的内容如下（vim /etc/apache2/mods-available/cgid.load ）：

```shell
LoadModule cgi_module /usr/lib/apache2/modules/mod_cgi.so     //默认有则不需要加
AddHandler cgi-script .cgi .pl .py .sh       // 我们加入这一句，使CGI支持 perl和python 和shell脚本
```

### 三，修改默认的cgi-bin的路径
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
### 四，重启Apache2 服务
```shell
sudo service apache2 restart
```

> 参考：http://httpd.apache.org/docs/2.4/howto/cgi.html