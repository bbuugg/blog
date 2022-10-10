---
title: Nginx-基础总结
date: 2021-06-16 23:43:03
cover: https://images.xiaozhuanlan.com/photo/2019/a7541d73fc14821573df7d3974317e4c.png
tags:
---

原文地址：https://www.mwbo.com/133.html

<!-- more -->

# 常规配置模板

```
#user  www www;
worker_processes auto;
error_log  /home/wwwlogs/nginx_error.log crit;
#pid        /usr/local/nginx/nginx.pid;

#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 655350;

events
	{
		use epoll;
		worker_connections 655350;
	}

http
	{
		include       mime.types;
		default_type  application/octet-stream;

		server_names_hash_bucket_size 128;
		client_header_buffer_size 32k;
		large_client_header_buffers 4 32k;
		client_max_body_size 50m;  # 如果报错413，可以尝试将这个参数改大
		server_tokens off;

		sendfile on;
		tcp_nopush     on;
		tcp_nodelay on;
		keepalive_timeout 60;


		fastcgi_connect_timeout 300;
		fastcgi_send_timeout 300;
		fastcgi_read_timeout 300;
		fastcgi_buffer_size 64k;
		fastcgi_buffers 4 64k;
		fastcgi_busy_buffers_size 128k;
		fastcgi_temp_file_write_size 256k;
		proxy_connect_timeout 600;
		proxy_read_timeout 600;
		proxy_send_timeout 600;
		proxy_buffer_size 64k;
		proxy_buffers   4 32k;
		proxy_busy_buffers_size 64k;
		proxy_temp_file_write_size 64k;

		gzip on;
		gzip_min_length  1k;
		gzip_buffers     4 16k;
		gzip_http_version 1.0;
		gzip_comp_level 2;
		gzip_types 	 text/plain application/x-javascript text/css application/xml text/xml application/json;
		gzip_vary on;
		log_format  access '$remote_addr - $remote_user [$time_local] $host '
                                   '"$request" $status $body_bytes_sent $request_time '
                                   '"$http_referer" "$http_user_agent" "$http_x_forwarded_for"'
                                   '$upstream_addr $upstream_status $upstream_response_time' ;

 #设置Web缓存区名称为cache_one，内存缓存空间大小为256MB，1天没有被访问的内容自动清除，硬盘缓存空间大小为30GB。
		proxy_temp_path   /home/proxy_temp_dir;
		proxy_cache_path  /home/proxy_cache_path levels=1:2 keys_zone=cache_one:256m inactive=1d max_size=30g;

        server {
            listen 80;
            server_name  _;
            return 403;
        }
        include vhost/*.conf;
}
```

以“exmaple.org”为例，如下为基于 upstream 负载均衡模式的配置：

```
upstream example_backend {
        server   127.0.0.1:9080;
        server   192.168.1.198:9080;
        server 172.16.0.4:80 weight=5 max_fails=3 fail_timeout=10s; # 权重、健康监测
        server 172.16.0.5:8080 backup; # 备份节点,
        ip_hash;  #调度算法
 }


server {
        listen 80;
        server_name www.example.org example.com .example.org;

    location / {
# 如果后端服务器出现502 或504错误代码的话nginx就不会请求某台服务器了,当后端服务器又工作正常了,nginx继续请求,这样一来达到了后端服务器健康状况检测的功能,
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
        proxy_pass http://example_backend;
        proxy_http_version 1.1;
        proxy_set_header        Host    $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

        # 设置后端连接超时时间
        proxy_connect_timeout   600;
        proxy_read_timeout  600;
        proxy_send_timeout  600;
        proxy_buffer_size   8k;
        proxy_temp_file_write_size  64k;

        # nginx本地cache开启
        proxy_cache cache_one;
        proxy_cache_valid 200 304 30d;
        proxy_cache_valid 301 302 404 1m;
        proxy_cache_valid any 1m;
        proxy_cache_key $host$request_uri;

        # 客户端缓存，在header中增加“Expires”
        expires 30d;
        add_header Cache-Control public;
        add_header X-Proxy-Cache $upstream_cache_status;

        proxy_set_header If-Modified-Since $http_if_modified_since;
        if_modified_since before;
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|ico|swf|xml|css|js)$ {
        proxy_pass      http://example_backend;
        proxy_set_header        Host    $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        expires 15d;
    }
    location ~ .*\.(jhtml)$ {
        proxy_pass      http://example_backend;
        proxy_set_header        Host    $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        expires -1;
    }
    access_log  logs/www.example.org.log;
}
```

其他的 proxy 配置：

1.proxy_set_header :在将客户端请求发送给后端服务器之前，更改来自客户端的请求头信息。
2.proxy_connect_timeout:配置Nginx与后端代理服务器尝试建立连接的超时时间。
3.proxy_read_timeout : 配置Nginx向后端服务器组发出read请求后，等待相应的超时时间。
4.proxy_send_timeout：配置Nginx向后端服务器组发出write请求后，等待相应的超时时间。
5.proxy_redirect :用于修改后端服务器返回的响应头中的Location和Refresh。

# 用户认证

```
# htpasswd -bc /usr/local/nginx/auth/passwd admin 123456
vim /usr/local/nginx/conf/vhost/www.conf
server {
        listen   80;
        server_name www.com;
        index  index.html index.htm;
        root /www;
location / {
         auth_basic "test";
         auth_basic_user_file /usr/local/nginx/auth/passwd;
}

#service nginx restart
```

# 解决跨域

```
# 提示： add_header 也可以添加到 server 中，这样当前 server 下都允许跨域
server
{
    listen 3002;
    server_name localhost;
    location /ok {
        proxy_pass http://localhost:3000;

        #   指定允许跨域的方法，*代表所有
        add_header Access-Control-Allow-Methods *;

        #   预检命令的缓存，如果不缓存每次会发送两次请求
        add_header Access-Control-Max-Age 3600;

        #   带cookie请求需要加上这个字段，并设置为true
        add_header Access-Control-Allow-Credentials true;

        #   表示允许这个域跨域调用（客户端发送请求的域名和端口）
        #   $http_origin动态获取请求客户端请求的域   不用*的原因是带cookie的请求不支持*号
        add_header Access-Control-Allow-Origin $http_origin;

        #   表示请求头的字段 动态获取
        add_header Access-Control-Allow-Headers $http_access_control_request_headers;

        #   OPTIONS预检命令，预检命令通过时才发送请求
        #   检查请求的类型是不是预检命令
        if ($request_method = OPTIONS){
            return 200;
        }
    }
}
```

# URL 重写

比如说访问某站点的路径为/forum/ , 此时想使用/bbs 来访问此站点需要做 url 重写如下

```
location / {
	rewrite ^/forum/?$ /bbs/ permanent;
}
```

比如说某站点有个图片服务器(10.0.0.1/p_w_picpaths/ ) 此时访问某站点上/p_w_picpaths/的资源时希望访问到图片服务器上的资源

```
location / {
	rewrite ^/p_w_picpaths/(.*\.jpg)$  /p_w_picpaths2/$1 break;
}
```

# 域名跳转

```
server {
    listen 80;
    server_name www.com;
    rewrite ^/ http://www.www.com/;
    # return 301 http://www.andy.com/;
}
```

```
if ($host != 'www.xyz.com') {         ####注意，这里很严格，if后面要有空格，!=两边都是空格。
   rewrite ^/(.*)$ http://www.xyz.com/$1 permanent;
}
```

# 域名镜像

```
server {
    listen 80;
    server_name  www.com;
    rewrite ^/(.*)$ http://www.www.com/$1 last;
}
```

判断表达式

-f 和 !-f 用来判断是否存在文件

-d 和 !-d 用来判断是否存在目录

-e 和 !-e 用来判断是否存在文件或目录

-x 和 !-x 用来判断文件是否可执行

# 防盗链

```
location ~* \.(gif|jpg|png|swf|flv)$ {
  valid_referers none blocked www.com;
  if ($invalid_referer) {
    rewrite ^/ http://www.com/403.html;
  }
```

# 会话保持

```
# ip_hash使用源地址哈希算法，将同一客户端的请求只发往同一个后端服务器（除非该服务器不可用）。
# 问题： 当后端服务器宕机后，session会话丢失；同一客户端会被转发到同一个后端服务器，可能导致负载失衡；
upstream backend {
    ip_hash;
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com down;
}
```

sticky_cookie_insert

```
# 使用sticky_cookie_insert 启用会话亲缘关系，会导致来自同一客户端的请求被传递到一组服务器的同一台服务器。与ip_hash不同之处在于，它不是基于IP来判断客户端的，而是基于cookie来判断。因此可以避免上述ip_hash中来自同一客户端导致负载失衡的情况(需要引入第三方模块才能实现)。
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    sticky_cookie_insert srv_id expires=1h domain=3evip.cn path=/;
}
server {
    listen 80;
    server_name 3evip.cn;
    location / {
    	proxy_pass http://backend;
    }
}
```

expires：设置浏览器中保持 cookie 的时间
domain：定义 cookie 的域
path：为 cookie 定义路径

# 日志切割

**示列一**

```
#!/bin/bash
# 适合单个网站日志文件

LOGS_PATH=/home/wwwroot/yunwei/logs
yesterday=`date  +"%F" -d  "-1 days"`
mv ${LOGS_PATH}/yunwei.log  ${LOGS_PATH}/yunwei-${yesterday}.log
kill -USR1 $(cat /var/logs/nginx.pid)
```

**示列二**

```
#nginx日志切割

# Nginx pid
NGINX_PID=$(cat /var/logs/nginx.pid)

# 多个日志文件
LOGS=(xxx.access.log xxx.access.log)

# Nginx日志路径目录
BASH_PATH="/www/wwwlogs"

# xxxx年xx月
lOG_PATH=$(date -d yesterday +"%Y%m")

# 昨天日期
DAY=$(date -d yesterday +"%d")

# 循环移动
for log in ${LOGS[@]}
do
	# 先判断日志目录是否存在
    [[ ! -d "${BASH_PATH}/${lOG_PATH}" ]] && mkdir -p ${BASH_PATH}/${lOG_PATH}

    # 进入日志目录
    cd ${BASH_PATH}
    mv ${log} ${lOG_PATH}/${DAY}-${log}
    #kill -USR1 `ps axu | grep "nginx: master process" | grep -v grep | awk '{print $2}'`
    kill -USR1 ${NGINX_PID}

    # 删除30天的备份,最好是移动到其他位置，不建议 rm -fr
    #find ${BASH_PATH}/${lOG_PATH} -mtime +30 -name "." -exec rm -fr {} \;
done
```

**示列三**

```
#!/bin/bash

#set the path to nginx log files
log_files_path="/usr/local/nginx/logs/"
log_files_dir=${log_files_path}$(date -d "yesterday" +"%Y")/$(date -d "yesterday" +"%m")
#set nginx log files you want to cut
log_files_name=(gw20 gw20-json)
#set the path to nginx.
nginx_sbin="/usr/bin/nginx"
#Set how long you want to save
save_days=10

############################################
#Please do not modify the following script #
############################################
mkdir -p $log_files_dir

log_files_num=${#log_files_name[@]}

#cut nginx log files
for((i=0;i<$log_files_num;i++));do
mv ${log_files_path}${log_files_name[i]}.log ${log_files_dir}/${log_files_name[i]}_$(date -d "yesterday" +"%Y%m%d").log
done

#delete 30 days ago nginx log files
find $log_files_path -mtime +$save_days -exec rm -rf {} \;

$nginx_sbin -s reload
```

**示列四**

```
server{

    if ($time_iso8601 ~ '(\d{4}-\d{2}-\d{2})') {
        set $day $1;
    }

	access_log  /www/wwwlogs/xxx.com-$day.log main;
	error_log  /www/wwwlogs/xxx.com.error.log;
}
```

动静分离

为加快网站解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力。 在动静分离的 tomcat 的时候比较明显，因为 tomcat 解析静态很慢，简单来说，是使用正则表达式匹配过滤，交给不同的服务器。

1、准备环境

```
192.168.62.159 代理服务器
192.168.62.157 动态资源
192.168.62.155 静态资源
```

2、配置 nginx 反向代理 upstream

```
[root@nginx-server conf.d]# cat upstream.conf

upstream static {
    server 192.168.62.155:80 weight=1 max_fails=1 fail_timeout=60s;
}

upstream phpserver {
    server 192.168.62.157:80 weight=1 max_fails=1 fail_timeout=60s;
}

server {
   listen      80;
   server_name     localhost;

   #动态资源加载
   location ~ \.(php|jsp)$ {
       proxy_pass http://phpserver;
       proxy_set_header Host $host:$server_port;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

   #静态资源加载
   location ~ .*\.(html|gif|jpg|png|bmp|swf|css|js)$ {
       proxy_pass http://static;
       proxy_set_header Host $host:$server_port;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

3、192.168.62.155 静态资源

```
#静态资源配置
server {
    listen 80;
    server_name     localhost;

    location ~ \.(html|jpg|png|js|css|gif|bmp|jpeg) {
        root /home/www/nginx;
        index index.html index.htm;
    }
}
```

4、192.168.62.157 动态资源

```
server {
    listen      80;
    server_name     localhost;

    location ~ \.php$ {
        root           /home/nginx/html;  #指定网站目录
        fastcgi_pass   127.0.0.1:9000;    #指定访问地址
        fastcgi_index  index.php;       #指定默认文件
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; #站点根目录，取决于root配置项
        include        fastcgi_params;  #包含nginx常量定义
    }
}
```

PHP的很多框架里面都是通过获取$_SERVER['PATH_INFO']处理路由 , 这个变量是通过nginx传递过来的 , 我们在nginx中经常见到下面两句

fastcgi_split_path_info ^(.+\.php)(/.*)$;
fastcgi_param PATH_INFO $fastcgi_path_info;

nginx默认获取不到PATH_INFO的值，得通过fastcgi_split_path_info指定定义的正则表达式来获取值。^(.+\.php)(/.*)$; 这个正则表达是有两个小括号 , 也就是有两个捕获。第二个捕获到的值会自动重新赋值给$fastcgi_path_info变量。第一个捕获的值会重新赋值给$fastcgi_script_name变量。如果访问 /index.php/test ,第二个捕获的是/test $fastcgi_path_info就是/test,因此就会把/test传递给php的$_SERVER['PATH_INFO']

## location 优先级

```
当有多条 location 规则时，nginx 有一套比较复杂的规则，优先级如下：
`精确匹配=
`前缀匹配^~（立刻停止后续的正则搜索）
`按文件中顺序的正则匹配~或~*
`匹配不带任何修饰的前缀匹配。

这个规则大体的思路是
`先精确匹配，没有则查找带有^~的前缀匹配，没有则进行正则匹配，最后才返回前缀匹配的结果（如果有的话）
```

## HTTPS 使用自颁发证书实现

```
# 建立存放https证书的目录
mkdir -pv /usr/local/nginx/conf/.sslkey
# 生成网站私钥文件
cd /usr/local/nginx/conf/.sslkey
openssl genrsa -out https.key 1024
# 生存网站证书文件,需要注意的是在生成的过程中需要输入一些信息根据自己的需要输入,但Common Name 项输入的必须是访问网站的FQDN
openssl req -new -x509 -key https.key -out https.crt
# 为了安全起见,将存放证书的目录权限设置为400
chmod -R 400 /usr/local/nginx/conf/.sslkey

#vim /usr/local/nginx/conf/vhost/www.conf
server {
        listen   443;
        server_name www.com;
        index  index.html index.htm;
        root /www;
        ssl                 on;
        ssl_protocols       SSLv3 TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         AES128-SHA:AES256-SHA:RC4-SHA:DES-CBC3-SHA:RC4-MD5;
        ssl_certificate     /usr/local/nginx/conf/.sslkey/https.crt;
        ssl_certificate_key /usr/local/nginx/conf/.sslkey/https.key;
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;
}

#重新启动nginx服务
service nginx restar
```

## 基于 HTTPS 配置核心配置

```
upstream example_backend {
    server   127.0.0.1:9080;
    server   192.168.1.198:9080;
 }
server {
        listen 80;
        server_name www.example.org example.org;
        rewrite ^/(.*)$  https://$host/$1 last;
 }
server {
    listen 443;
    server_name www.example.org example.org;

    ssl on;
    ssl_certificate      /usr/local/nginx/conf/ssl/example.crt;
    ssl_certificate_key  /usr/local/nginx/conf/ssl/example.key;
    ssl_session_timeout  5m;
    ssl_protocols  SSLv3 TLSv1 TLSv1.2 TLSv1.1;
    ssl_ciphers HIGH:!aNULL:!MD5:!EXPORT56:!EXP;
    ssl_prefer_server_ciphers   on;

    location / {
        ...
    }
}
```

## 根据页面不存在则自定义跳转

```
if (!-f $request_filename) {
      rewrite ^(/.*)$ http://www.com permanent;
}
```

## 直接输出消息

### 直接返回文本：
```
location / {
	default_type    text/plain;
	return 502 "服务正在升级，请稍后再试……";
}
```

### 也可以使用html标签格式：
```
location / {
	default_type    text/html;
	return 502 "服务正在升级，请稍后再试……";
}
```
### 也可以直接返回json文本：
```
location / {
	default_type    application/json;
	return 502 '{"status":502,"msg":"服务正在升级，请稍后再试……"}';
}
```

## 根据文件类型设置过期时间

```
location ~* \.(js|css|jpg|jpeg|gif|png|swf)$ {
    if (-f $request_filename) {
        expires 1h;
        break;
    }
}
```

## 根据域名自定义跳转

```
if ( $host = 'www.baidu.com' ) {
	rewrite ^/(.*)$ http://baidu.com/$1 permanent;
}
```

## 浏览器的类型,作出相应的跳转

```
# 根据浏览器头部 URL 重写到指定目录
if ($http_user_agent ~* MSIE) {
	rewrite  ^(.*)$  /msie/$1  break;
}

# 判断是否是手机端
if ( $http_user_agent ~* "(Android|iPhone|Windows Phone|UC|Kindle)" ) {
	rewrite ^/(.*)$ http://m.qp.com$uri redirect;
}
```

## 禁止访问目录|文件

```
location ~* \.(txt|doc)${
    root /data/www/wwwroot/linuxtone/test;
    deny all;
}
```

如果前端是反向代理的情况下：

```
location /admin/ {
	allow 192.168.1.0/24;
	deny all;
}

# 后端
# set $allow false;
# if ($allow = false) { return 403;}
if ($http_x_forwarded_for !~* ^192\.168\.1\.*) {
	return 403;
}
```

## 添加模块–支持 Websock

Nginx 动态添加模块

版本平滑升级，和添加模块操作类似

## 准备模块

这里以 nginx-push-stream-module 为例,模块我放在 /data/module 下，你也可以放在其他位置

```
mkdir -p /data/module && cd /data/module/
git clone http://github.com/wandenberg/nginx-push-stream-module.git
```

## 查看 Nginx 已安装模块

```
/usr/local/nginx/sbin/nginx -V
--prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-pcre
```

## 备份源执行文件

备份原来的 nginx 可执行文件

```
cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx_bak
#　有必要的话，可以再备份下配置文件，以防万一
```

## 下载源码编译

下载相同版本的 Nginx 源码包编译（以前安装时的源码包），如果已经删除了可重新下载，版本相同即可

```
wget http://nginx.org/download/nginx-1.16.1.tar.gz
tar xf nginx-1.16.1.tar.gz
cd nginx-1.16.1
 ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-pcre --add-module=/data/module/nginx-push-stream-module

# 编译Nginx（千万不要make install，不然就真的覆盖了）
make
mv objs/nginx /usr/local/nginx/sbin/
```

## 查看是否安装

```
/usr/local/nginx/sbin/nginx -V
--prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-http_gzip_static_module --with-http_flv_module --with-http_mp4_module --with-pcre --add-module=/data/module/nginx-push-stream-module
```

## 添加模块–支持健康检查模块

## 缺陷？

自带健康检查的缺陷：

Nginx 只有当有访问时后，才发起对后端节点探测。
如果本次请求中，节点正好出现故障，Nginx 依然将请求转交给故障的节点,然后再转交给健康的节点处理。所以不会影响到这次请求的正常进行。但是会影响效率,因为多了一次转发
自带模块无法做到预警
被动健康检查
使用第三访模块 nginx_upstream_check_module：

区别于 nginx 自带的非主动式的心跳检测，淘宝开发的 tengine 自带了一个提供主动式后端服务器心跳检测模块
若健康检查包类型为 http，在开启健康检查功能后，nginx 会根据设置的间隔向指定的后端服务器端口发送健康检查包，并根据期望的 HTTP 回复状态码来判断服务是否健康。
后端真实节点不可用，则请求不会转发到故障节点
故障节点恢复后，请求正常转发

## 准备模块

```
yum install patch git -y
cd /usr/local/src
git clone https://github.com/yaoweibin/nginx_upstream_check_module.git
```

## 打补丁

```
# 需进入源码包打补丁
# 个人习惯，源码放在 /usr/local/src
# 例如我的 nginx 源码包存放： /usr/local/src/nginx-1.16.1 , 若源码已经删除，那么去官网上再下载同版本
cd /usr/local/src/nginx-1.16.1
patch -p1 < ../nginx_upstream_check_module/check_1.16.1+.patch
```

## 重新编译

```
nginx -V
# configure arguments: --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --add-module=/root/nginx_upstream_check_module/

# 在运行中的 nginx 添加模块； 首先一点: 修改东西之前要先备份
mv /usr/loca/nginx/sbin/nginx{,_bak}


./configure --prefix=/usr/local/nginx \
--user=www --group=www \
--with-http_ssl_module \
--with-http_stub_status_module \
--add-module=../nginx_upstream_check_module
make


# **别手贱， 千万不要 make install**
cp objs/nginx /usr/local/nginx/sbin/
```

## 查看模块

```
nginx -V
configure arguments: --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --add-module=../nginx_upstream_check_module
```

## 如何使用？

```
http {

    upstream cluster {
        server 192.168.0.1:80;
        server 192.168.0.2:80;
	    server 127.0.0.1:80;
        check interval=5000 rise=1 fall=3 timeout=4000;

        #check interval=3000 rise=2 fall=5 timeout=1000 type=ssl_hello;
        #check interval=3000 rise=2 fall=5 timeout=1000 type=http;
        #check_http_send "HEAD / HTTP/1.0\r\n\r\n";
        #check_http_expect_alive http_2xx http_3xx;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://cluster;
        }

        location /status {
            # 默认html，请求方式： check_status html|json|xml;
            # allow 允许的IP地址
            check_status;
            access_log   off;
            allow SOME.IP.ADD.RESS;
            deny all;
       }
    }

}

# kill -USER2 `cat /usr/local/nginx/logs/nginx.pid` #热升级nginx,如果当前nginx不是用绝对路径下的nginx命令启动的话，热升级无效。
# 只能 `nginx -s stop` && /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf`
```

## 验证

```
# curl http://127.0.0.1/status?format=http
# curl http://127.0.0.1/status?format=xml
curl http://127.0.0.1/status?format=json
"""
{"servers": {
  "total": 3,
  "generation": 2,
  "server": [
    {"index": 0, "upstream": "cluster", "name": "192.168.0.1:80", "status": "down", "rise": 0, "fall": 432, "type": "tcp", "port": 0},
    {"index": 1, "upstream": "cluster", "name": "192.168.0.2:80", "status": "down", "rise": 0, "fall": 432, "type": "tcp", "port": 0},
    {"index": 2, "upstream": "cluster", "name": "127.0.0.1:80", "status": "up", "rise": 4, "fall": 0, "type": "tcp", "port": 0}
  ]
}}
"""
```

![img](https://www.mwbo.com/wp-content/uploads/2021/06/6666.png)

## 注意事项

如果后端是基于域名访问，可使用 check_http_send “GET /xxx HTTP/1.0\r\n HOST www.xxx.com\r\n\r\n”;方式在请求时添加请求头信息

## 参数详解

interval： 检测间隔 3 秒
fall: 连续检测失败次数 5 次时，认定 relaserver is down
rise: 连续检测成功 2 次时，认定 relaserver is up
timeout: 超时 1 秒
default_down: 初始状态为 down,只有检测通过后才为 up
type: 检测类型方式 tcp
tcp :tcp 套接字,不建议使用，后端业务未 100%启动完成,前端已经放开访问的情况
ssl_hello： 发送 hello 报文并接收 relaserver 返回的 hello 报文
http: 自定义发送一个请求，判断上游 relaserver 接收并处理
mysql: 连接到 mysql 服务器，判断上游 relaserver 是否还存在
ajp: 发送 AJP Cping 数据包，接收并解析 AJP Cpong 响应以诊断上游 relaserver 是否还存活(AJP tomcat 内置的一种协议)
fastcgi: php 程序是否存活

## GIthub 地址

[https://github.com/yaoweibin/nginx_upstream_check_module](https://www.mwbo.com/?golink=aHR0cHM6Ly9naXRodWIuY29tL3lhb3dlaWJpbi9uZ2lueF91cHN0cmVhbV9jaGVja19tb2R1bGU=)

## 添加模块–支持国家城市模块

安装依赖 libmaxmindd

因为需要读取在 GeoIP2 的 IP 数据库库，需要使用到 libmaxminddb 中的一个 C 库

**pay源码**

```
wget https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz
tar zxvf libmaxminddb-1.3.2.tar.gz
cd libmaxminddb-1.3.2
./configure
make
make  install

# 添加库路径并更新库
sh -c "echo /usr/local/lib  >> /etc/ld.so.conf.d/local.conf"
ldconfig
```

**yum**

```
yum install libmaxminddb-devel -y
```

## 下载 GeoIP 源码

```
wget https://github.com/leev/ngx_http_geoip2_module/archive/3.2.tar.gz
tar zxvf 3.2.tar.gz
```

## Nginx 重新编译

```
 ./configure --prefix=/usr/local/nginx --add-module=../ngx_http_geoip2_module-3.2
make && make install
```

## 下载 GeoLite

这个库是为了将 IP 地址翻译成具体的地址信息，下载需要注册…
URL: https://www.maxmind.com/en/accounts/current/people/current 账号： xxxx@qq.com 密码： xxx..

```
gunzip GeoLite2-City.mmdb.gz
gunzip GeoLite2-Country.mmdb.gz
mkdir /data/geoip
mv GeoLite2-City.mmdb  /data/geoip/city.mmdb
mv GeoLite2-Country.mmdb /data/geoip/country.mmdb
```

## 启用 GeoIP

```
vim /usr/local/nginx/conf/nginx.conf
http {
    geoip2 /data/geoip/country.mmdb {
        $geoip2_data_country_code default=CN country iso_code;
        $geoip2_data_country_name country names en;
    }
    geoip2 /data/geoip/city.mmdb {
        $geoip2_data_city_name default=Shenzhen city names en;
    }

    server {
        listen       80;
        server_name  localhost;
        location / {
            add_header geoip2_data_country_code $geoip2_data_country_code;
            add_header geoip2_data_city_name $geoip2_data_city_name;
            if ($geoip2_data_country_code = CN){
                root /data/webroot/cn;
            }
            if ($geoip2_data_country_code = US){
                root /data/webroot/us;
            }
        }
｝
```

## 检查 GeoIP

```
mkdir /data/webroot/us
mkdir /data/webroot/cn
echo "US Site" > /data/webroot/us/index.html
echo "CN Site" > /data/webroot/cn/index.html
curl 试一试
```

## 内置变量

```
http://wiki.nginx.org/HttpCoreModule#Variables   官方文档
$arg_PARAMETER
$args
$binary_remote_addr
$body_bytes_sent
$content_length
$content_type
$cookie_COOKIE
$document_root
$document_uri
$host
$hostname
$http_HEADER
$sent_http_HEADER
$is_args
$limit_rate
$nginx_version
$query_string
$remote_addr
$remote_port
$remote_user
$request_filename
$request_body
$request_body_file
$request_completion
$request_method
$request_uri
$scheme
$server_addr
$server_name
$server_port
$server_protocol
$uri
```

# nginx配置location

基本语法：location [=||*|^~] /uri/ { … }

```
= 严格匹配。如果这个查询匹配，那么将停止搜索并立即处理此请求。
~ 为区分大小写匹配(可用正则表达式)
!~为区分大小写不匹配
~* 为不区分大小写匹配(可用正则表达式)
!~*为不区分大小写不匹配
^~ 如果把这个前缀用于一个常规字符串,那么告诉nginx 如果路径匹配那么不测试正则表达式。
123456
```

例子

```
location = / {
 # 只匹配 / 查询。
}
location / {
 # 匹配任何查询，因为所有请求都以 / 开头。但是正则表达式规则和长的块规则将被优先和查询匹配。
}
location ^~ /images/ {
 # 匹配任何以 /images/ 开头的任何查询并且停止搜索。任何正则表达式将不会被测试。
}
location ~*.(gif|jpg|jpeg)$ {
 # 匹配任何以 gif、jpg 或 jpeg 结尾的请求。
}
location ~*.(gif|jpg|swf)$ {
  valid_referers none blocked start.igrow.cn sta.igrow.cn;
  if ($invalid_referer) {
    #防盗链
    rewrite ^/ http://$host/logo.png;
  }
}
```

# try_files

```
location / {
            try_files $uri $uri/ /index.php?$query_string;
}
```

当用户请求 `http://localhost/example` 时，这里的 `$uri` 就是 `/example`。 
try_files 会到硬盘里尝试找这个文件。如果存在名为 `/$root/example`（其中 `$root` 是项目代码安装目录）的文件，就直接把这个文件的内容发送给用户。 
显然，目录中没有叫 example 的文件。然后就看 `$uri/`，增加了一个 `/`，也就是看有没有名为 `/$root/example/` 的目录。 
又找不到，就会 fall back 到 try_files 的最后一个选项 /index.php，发起一个内部 “子请求”，也就是相当于 nginx 发起一个 HTTP 请求到 `http://localhost/index.php`。 

```
loaction / {

try_files $uri @apache

}

loaction @apache{

proxy_pass http://127.0.0.1:88

include aproxy.conf

}
```

`try_files`方法让`Ngxin`尝试访问后面得`$uri`链接，并进根据`@apache`配置进行内部重定向。

当然`try_files`也可以以错误代码赋值，如`try_files /index.php = 404 @apache`，则表示当尝试访问得文件返回`404`时，根据`@apache`配置项进行重定向。

# Nginx配置中的if判断

当rewrite的重写规则满足不了需求时，比如需要判断当文件不存在时、当路径包含xx时等条件，则需要用到if

## if语法

```
if (表达式) {
    ...
}
```

表达式语法：

当表达式只是一个变量时，如果值为空或任何以0开头的字符串都会当做false
直接比较变量和内容时，使用=或!=

```
-f和!-f用来判断是否存在文件
-d和!-d用来判断是否存在目录
-e和!-e用来判断是否存在文件或目录
-x和!-x用来判断文件是否可执行
```

为了配置if的条件判断，这里需要用到nginx中内置的全局变量

```
$args               这个变量等于请求行中的参数，同$query_string
$content_length     请求头中的Content-length字段。
$content_type       请求头中的Content-Type字段。
$document_root      当前请求在root指令中指定的值。
$host               请求主机头字段，否则为服务器名称。
$http_user_agent    客户端agent信息
$http_cookie        客户端cookie信息
$limit_rate         这个变量可以限制连接速率。
$request_method     客户端请求的动作，通常为GET或POST。
$remote_addr        客户端的IP地址。
$remote_port        客户端的端口。
$remote_user        已经经过Auth Basic Module验证的用户名。
$request_filename   当前请求的文件路径，由root或alias指令与URI请求生成。
$scheme             HTTP方法（如http，https）。
$server_protocol    请求使用的协议，通常是HTTP/1.0或HTTP/1.1。
$server_addr        服务器地址，在完成一次系统调用后可以确定这个值。
$server_name        服务器名称。
$server_port        请求到达服务器的端口号。
$request_uri        包含请求参数的原始URI，不包含主机名，如：”/foo/bar.php?arg=baz”。
$uri                不带请求参数的当前URI，$uri不包含主机名，如”/foo/bar.html”。
$document_uri       与$uri相同。
```

举例说明
1、如果文件不存在则返回400

```
if (!-f $request_filename) {
    return 400;
}
```

2、如果host不是jouypub.com，则301到jouypub.com中

```
if ( $host != 'jouypub.com' ){
    rewrite ^/(.*)$ https://jouypub.com/$1 permanent;
}
```

3、如果请求类型不是POST则返回405

```
if ($request_method = POST) {
    return 405;
}
```

4、如果参数中有a=1则301到指定域名

```
if ($args ~ a=1) {
    rewrite ^ http://example.com/ permanent;
}
```

5、在某种场景下可结合location规则来使用，如：

```
#访问 /test.html 时
location = /test.html {
    #设置默认值为xiaowu
    set $name xiaowu;
    #如果参数中有 name=xx 则使用该值 
    if ($args ~* name=(\w+?)(&|$)) {
            set $name $1;
    }
    #301
    rewrite ^ /$name.html permanent;
}
#上面表示：
#/test.html => /xiaowu.html
#/test.html?name=ok => /ok.html?name=ok
```

# 强制跳转www
```
if ($host != 'www.1kmb.com') {
	rewrite ^/(.*) https://www.1kmb.com/$1 permanent;
}
```

# 代理中的几点区别
在nginx中配置proxy_pass代理转发时，如果在proxy_pass后面的url加/，表示绝对根路径；如果没有/，表示相对路径，把匹配的路径部分也给代理走。
假设下面四种情况分别用 http://127.0.0.1/proxy/test.html 进行访问。

第一种：

```shell
location /proxy/ {
    proxy_pass http://127.0.0.1/;
}
```

代理到URL：http://127.0.0.1/test.html

第二种（相对于第一种，最后少一个 / ）

```shell
location /proxy/ {
    proxy_pass http://127.0.0.1;
}
```
代理到URL：http://127.0.0.1/proxy/test.html

第三种：

```
location /proxy/ {
    proxy_pass http://127.0.0.1/abc/;
}
```

代理到URL：http://127.0.0.1/abc/test.html

第四种（相对于第三种，最后少一个 / ）

```
location /proxy/ {
    proxy_pass http://127.0.0.1/abc;
}
```
代理到URL：http://127.0.0.1/abctest.html


# Nginx限流

高并发系统有三把利器：缓存、降级和限流；限流的目的是通过对并发访问/请求进行限速来保护系统，一旦达到限制速率则可以拒绝服务（定向到错误页）、排队等待（秒杀）、降级（返回兜底数据或默认数据）。 高并发系统常见的限流有：限制总并发数（数据库连接池）、限制瞬时并发数（如nginx的limit_conn模块，用来限制瞬时并发连接数）、限制时间窗口内的平均速率（nginx的limit_req模块，用来限制每秒的平均速率）。
 另外还可以根据网络连接数、网络流量、CPU或内存负载等来限流 

## Module ngx_http_limit_conn_module
http://nginx.org/en/docs/http/ngx_http_limit_conn_module.html

## 限流算法

计数器，令牌桶，漏桶

## 请求限制

依赖于nginx的ngx_http_limit_req_module模块，需要在http段配置参照标准和状态缓存区大小

- limit_req_zone 只能配置在 http 范围内；
- $binary_remote_addr 表示客户端请求的IP地址；
- mylimit 自己定义的变量名；
- rate 请求频率，每秒允许多少请求；

limit_req 与 limit_req_zone 对应，burst 表示缓存的请求数，也就是任务队列。

例如如下配置

```
# 定义了一个 mylimit 缓冲区（容器），请求频率为每秒 1 个请求（nr/s）
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=1r/s;
server {
    listen  80;
    location / {
        # nodelay 不延迟处理
        # burst 是配置超额处理,可简单理解为队列机制
        # 上面配置同一个 IP 没秒只能发送一次请求（1r/s），这里配置了缓存3个请求，就意味着同一秒内只能允许 4 个任务响应成功，其它任务请求则失败（503错误）
        limit_req zone=mylimit burst=3 nodelay;
        proxy_pass http://localhost:7070;
    }
}
```

## 并发限制

Nginx 并发限制的功能来自于 ngx_http_limit_conn_module 模块，跟请求配置一样，使用它之前，需要先定义参照标准和状态缓存区。

- limit_conn_zone 只能配置在 http 范围内；
- $binary_remote_addr 表示客户端请求的IP地址；
- myconn 自己定义的变量名（缓冲区）；
- limit_rate 限制传输速度
- limit_conn 与 limit_conn_zone 对应，限制网络连接数

下面的配置就是定义了使用客户端的 IP 作为参照依据，并使用一个 10M 大小的状态缓存区。限定了每个IP只允许建立一个请求连接，同时传输的速度最大为 1024KB

```
# 定义了一个 myconn 缓冲区（容器）
limit_conn_zone $binary_remote_addr zone=myconn:10m;
server {
    listen  70;
    location / {
        # 每个 IP 只允许一个连接
        limit_conn myconn 1;
        # 限制传输速度（如果有N个并发连接，则是 N * limit_rate）
        limit_rate 1024k;
        proxy_pass http://localhost:7070;
    }
}
```

原文地址：https://cloud.tencent.com/developer/article/1786015

# Nginx代理后服务端使用remote_addr获取真实IP

在代理服务器的Nginx配置（yourWebsite.conf）的location /中添加：

```
#获取客户端IP
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header REMOTE-HOST $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```
在业务服务器的Nginx配置（yourWebsite.conf）的location中添加：
```
fastcgi_param  HTTP_X_FORWARDED_FOR $http_x_forwarded_for;
```
配置到这，可以用HTTP_X_FORWARDED_FOR获取客户端真实IP，以PHP为例，$_SERVER['HTTP_X_FORWARDED_FOR']，但是remote_addr还是代理服务器的IP，接着往下配置，把remote_addr也配置成真实IP。

在业务服务器的Nginx配置（yourWebsite.conf）的location中继续添加：
```
set_real_ip_from 172.18.209.11/24;#这里的IP是代理服务器的IP，也可以是IP段。意思是把该IP请求过来的x_forwarded_for设为remote_addr
real_ip_header X-Forwarded-For;
```
Tip：添加上面两行之前，需要查看Nginx是否安装了realip模块，Nginx默认是不安装的，查看命令 nginx -V ，结果如下所示，如果没有realip模块，需要先安装。
```
nginx version: nginx/1.14.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_ssl_module --with-http_realip_module --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_random_index_module --with-http_degradation_module --with-http_slice_module --with-http_stub_status_module --with-stream --with-stream=dynamic --with-stream_ssl_module --with-pcre --add-module=/usr/local/nginx_upstream_check_module-master/
```

# 关于nginx不支持PATHINFO问题的解决

配置好的NGINX配置文件

    server {
        listen       80;
        server_name  www.newmvc.com;
     
        root /Users/likang/Desktop/mvc_new;
        #charset koi8-r;
     
        access_log  logs/www.newmvc.com.access.log  main;
        error_log  logs/www.newmvc.com.error.log;
     
        location / {
            autoindex on;
            index index.php index.html index.htm;
        }
        #error_page  404              /404.html;
     
        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
        }
     
        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}
     
        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            include        fastcgi_params;
     
     
            set $real_script_name $fastcgi_script_name;
            if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
                set $real_script_name $1;
                set $path_info $2;
            }
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            fastcgi_param PATH_INFO $path_info;
        }
     
        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }




需要注意的是 

```
 location ~ \.php
```


这个地方$ 要去掉

    还有一种更简单的办法，还是不支持pathinfo使用另外的路由模式，也能解决问题，建议使用第一种办法

```
if (!-e $request_filename) {
   rewrite  ^index.php/(.*)$  /index.php?$1  last;
   break;
}
```

## 反向代理后视频需要全部缓冲后才能播放

可以尝试添加下面的头部

```shell
proxy_set_header Range $http_range;
proxy_set_header If-Range $http_if_range;
```