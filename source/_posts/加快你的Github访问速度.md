---
title: 加快你的Github访问速度
date: 2021-11-14 17:49:39
cover: /images/20221002/e84c0c6f41b32390e730ebb989234520.webp
tags:
---

有时候打开Github是真的慢，紧急时刻总是打不开，所以在这里写下加快Github访问的一些步骤，供大家参考

<!-- more -->

# 前期准备

## 云服务器一台

我使用了Docker, 你也可以直接装到当前系统， 服务器的话国外的最好，因为国外访问Github是比较快的。

## 拉取Nginx镜像
https://registry.hub.docker.com/_/nginx
```
docker pull nginx
```

这个版本是真的新啊

## 启动

```
docker run -itd -p 89:80 --name nginx nginx 
```

> 以下操作均在容器中进行

## 官网下载Nginx源码

http://nginx.org/en/download.html

```
wget http://nginx.org/download/nginx-1.21.4.tar.gz
```

## 下载要新增的模块

https://github.com/chobits/ngx_http_proxy_connect_module

```
git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
```

# 重新编译Nginx

## 查看Nginx编译参数

```
nginx -V
```

将编译参数保存起来

## 编译

### 解压下载的Nginx和模块

>如果需要的话

```
tar -zxf nginx-***.tar.gz
```

进入Nginx源码路径，根据你的Nginx版本及下面的对应关系，执行类似下面的命令

| nginx version   | enable REWRITE phase | patch                                                        |
| --------------- | -------------------- | ------------------------------------------------------------ |
| 1.4.x ~ 1.12.x  | NO                   | [proxy_connect.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect.patch) |
| 1.4.x ~ 1.12.x  | YES                  | [proxy_connect_rewrite.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite.patch) |
| 1.13.x ~ 1.14.x | NO                   | [proxy_connect_1014.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_1014.patch) |
| 1.13.x ~ 1.14.x | YES                  | [proxy_connect_rewrite_1014.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_1014.patch) |
| 1.15.2          | YES                  | [proxy_connect_rewrite_1015.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_1015.patch) |
| 1.15.4 ~ 1.16.x | YES                  | [proxy_connect_rewrite_101504.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_101504.patch) |
| 1.17.x ~ 1.18.0 | YES                  | [proxy_connect_rewrite_1018.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_1018.patch) |
| 1.19.x ~ 1.21.0 | YES                  | [proxy_connect_rewrite_1018.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_1018.patch) |
| 1.21.1          | YES                  | [proxy_connect_rewrite_102101.patch](https://github.com/chobits/ngx_http_proxy_connect_module/blob/master/patch/proxy_connect_rewrite_102101.patch) |


```
patch -p1 < /path/to/ngx_http_proxy_connect_module/patch/proxy_connect.patch
./configure --add-module=/path/to/ngx_http_proxy_connect_module
make && make install
```

注意，上面的编译参数要把你刚刚复制的那段加上去安装完成

## 添加配置

我们需要修改一下配置，
```
server {
     listen                         80;
     resolver                       8.8.8.8;
     proxy_connect;
     proxy_connect_allow            443 563;
     proxy_connect_connect_timeout  10s;
     proxy_connect_read_timeout     10s;
     proxy_connect_send_timeout     10s;
	
	 # 下面这个配置应该需要改下
     location / {
         proxy_pass $scheme://$host/;
         proxy_set_header Host $host;
     }
 }
```

> 这个配置你可能需要根据需要做相应修改，例如你需要转发某个header头，你可以使用

```
proxy_set_header Accpet "*/*"
```

然后重载一下

```
nginx -s reload
```

或者直接重启

# 使用

修改你电脑或者浏览器的代理配置，如下

![](/images/20211114/64756e1a123133753a1478a85f46de5c.png)

这里的127.0.0.1是你服务器的ip地址，89是你映射到nginx的端口，可以看下

![](/images/20211114/115a8544b17a91ac4c746537af39e822.png)

如果远程地址是[你服务器ip]:89 就说明成功了，如果你使用的是国外的机器那么速度应该会很快。

# 最后
教程是前几天搭建之后总结的，总结的时候并没有再操作一遍，所以可能会有一些问题，如果有问题可以留言给我。

还可以使用nginx代理socket，可以参考下面两篇文章

[Nginx折腾－TCP代理和负载均衡](https://www.zybuluo.com/orangleliu/note/478334 "Nginx折腾－TCP代理和负载均衡")

[Nginx支持Socket转发过程详解](https://www.cnblogs.com/knowledgesea/p/6497783.html "Nginx支持Socket转发过程详解")