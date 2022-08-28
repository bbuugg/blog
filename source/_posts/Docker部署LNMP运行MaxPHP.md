---
title: Docker部署LNMP运行MaxPHP
date: 2022-04-06 23:37:38
tags:
---

## 环境

- linux[腾讯云ubuntu20.04]

**也可以手动安装docker**

```
apt install docker.io
```

## 安装软件

lnmp指的是linux，nginx，mysql，php。 MaxPHP是运行在php的cli模式下的框架，所以不需要安装fpm。下面介绍docker安装lnmp的一些步骤，来运行MaxPHP类似的框架，这里软件均选择最新版本

> 为了多个容器可以通信，需要新建一个网桥

```
docker network create -d bridge lnmp
```

### 安装nginx

```shell
docker pull nginx
```

拉取镜像后使用下面的命令运行容器

```shell
docker run -itd --name nginx -v /www:/www -p 80:80 -p 443:443 --network lnmp <镜像id>
```

这里我做了http和https默认两个端口的映射，下面是我的网站配置文件，具体需要代理的主机需要使用下面的命令查看
```
docker network inspect lnmp
```

```
server
{
    listen 80;
    listen 443 ssl http2;
    server_name 1kmb.com www.1kmb.com;
    index index.php index.html index.htm default.php default.htm default.html;
    root /www/wwwroot/1kmb.com.main/public;
    location / {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      if (!-f $request_filename ) {
        proxy_pass http://127.0.0.1:9999;
      }
    }
    #SSL-START SSL相关配置，请勿删除或修改下一行带注释的404规则
    #error_page 404/404.html;
    #limit_conn perserver 50;
    #limit_conn perip 15;
    #limit_rate 256k;
    #HTTP_TO_HTTPS_START
    
    if ($host !~ "www") {
      rewrite ^(/.*)$ https://www.$host$1 permanent;
    }
    
    if ($server_port !~ 443){
        rewrite ^(/.*)$ https://$host$1 permanent;
    }
    #HTTP_TO_HTTPS_END
    ssl_certificate    /www/server/panel/vhost/cert/1kmb.com.main/fullchain.pem;
    ssl_certificate_key    /www/server/panel/vhost/cert/1kmb.com.main/privkey.pem;
    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    add_header Strict-Transport-Security "max-age=31536000";
    error_page 497  https://$host$request_uri;

    #SSL-END
    
    #ERROR-PAGE-START  错误页配置，可以注释、删除或修改
    #error_page 404 /404.html;
    #error_page 502 /502.html;
    #ERROR-PAGE-END
    
    #PHP-INFO-START  PHP引用配置，可以注释或修改
    # include enable-php-00.conf;
    #PHP-INFO-END
    
    #REWRITE-START URL重写规则引用,修改后将导致面板设置的伪静态规则失效
    # include /www/server/panel/vhost/rewrite/1kmb.com.main.conf;
    #REWRITE-END
    
    #禁止访问的文件或目录
    location ~ ^/(\.user.ini|\.htaccess|\.git|\.svn|\.project|LICENSE|README.md)
    {
        return 404;
    }
    
    #一键申请SSL证书验证目录相关设置
    location ~ \.well-known{
        allow all;
    }
    
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires      30d;
        error_log /dev/null;
        access_log /dev/null;
    }
    
    location ~ .*\.(js|css)?$
    {
        expires      12h;
        error_log /dev/null;
        access_log /dev/null; 
    }
    access_log  /www/wwwlogs/1kmb.com.main.log;
    error_log  /www/wwwlogs/1kmb.com.main.error.log;
}

server {
  listen 443 ssl;
  server_name ws.1kmb.com;
  location / {
    proxy_pass http://127.0.0.1:8787;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_http_version 1.1;
    proxy_set_header   Sec-Websocket-Version 13;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }
    ssl_certificate    /www/wwwroot/7328958_ws.1kmb.com.pem;
    ssl_certificate_key    /www/wwwroot/7328958_ws.1kmb.com.key;
    ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+AES128:RSA+AES128:EECDH+AES256:RSA+AES256:EECDH+3DES:RSA+3DES:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
}
```

我开启了websocket服务，所以配置了$connection_upgrade变量，配置方法如下

## 配置 “$connection_upgrade” 变量

连接升级通常与 WebSockets 结合使用。 在 nginx 中，我们可以根据 `$http_upgrade` 变量将 HTTP 连接升级为 WebSocket 连接。

我们可以使用 **map** 块在 nginx 中定义连接和 http 升级之间的依赖关系：

```nginx
map $http_upgrade $connection_upgrade {  
    default upgrade;
    ''      close;
}
```

如果 Upgrade 标头设置为 ''，此 **map** 块告诉 nginx 正确设置相关的 Connection 标头来关闭连接。

将 map 块放入 nginx 配置的 http 块中。 nginx 配置的默认文件路径是 **/etc/nginx/nginx.conf** 。

这是一个使用定义 $connection_upgrade 变量的 map 块的 nginx 配置示例。

```
user www-data;  
worker_processes auto;  
pid /run/nginx.pid;

events {  
        multi_accept       on;
        worker_connections 65535;
}

http {  
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	…

	# Connection header for WebSocket reverse proxy
	map $http_upgrade $connection_upgrade {
	    default upgrade;
	    ''      close;
	}
	# further configurations …
}
```

保存更新的 nginx 配置文件。 然后，使用 nginx -t 再次检查配置文件：

```bash
$ sudo nginx -t

nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
nginx: configuration file /etc/nginx/nginx.conf test is successful  
```

如果配置文件出错导致容器不能启动，则可以使用下面命令拷贝配置文件到容器外部修改后再拷贝进去

```
docker cp /nginx.conf <容器id>:/etc/nginx/nginx.conf
```

### 安装php

```shell
docker pull php
```

运行容器

```
docker run -itd --name php81 --network lnmp -v /www:/www <容器id>
```

添加pcntl（maxphp的切面实现使用了子进程扫描），redis，pdo，pdo_mysql扩展，从官网下载对应版本的源码包，解压后进入ext目录的对应扩展目录，执行

```
phpize
./configure --enable-pcntl --with-php-config=/usr/local/php-config 
make && make install
```

然后将扩展添加到配置文件中，配置文件可以通过php --ini查看

如果出现下面的报错
```
error: openssl/ssl.h: No such file or directory
```

就执行下下面的命令
```
sudo apt-get install openssl
sudo apt-get install libssl-dev build-essential zlibc zlib-bin libidn11-dev libidn11
```


## 安装mysql

```
docker pull mysql
```

```
docker run -itd --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root <容器id>
```

