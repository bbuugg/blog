---
title: Ubuntu20.04 中文显示不正确的解决方案
date: 2021-06-15 20:07:17
cover: https://ts1.cn.mm.bing.net/th/id/R-C.713ed360603e1e9fe654f0645405e624?rik=lPjb9FI48Vh5iw&riu=http%3a%2f%2fwww.linuxidc.com%2fupload%2f2007_12%2f07122213397704.jpg&ehk=frc7BChUYoWJlpKuapnRrGSVP82UIURmYj3R4XhGNgo%3d&risl=&pid=ImgRaw&r=0
tags:
---

今天又买了一台腾讯云，想学学linux，就没有安装宝塔。搭建好网站后发现中文显示有问题。查阅一番资料后知道原来需要安装语言包。
如下图是没有安装语言包的文件列表:

<!-- more -->

```
drwxr-xr-x 11 root root  4096 Jun 14 09:52  ./
drwxr-xr-x  4 root root  4096 Jun 14 09:53  ../
-rwxr-xr-x  1 root root    18 Apr 28 22:24  .htaccess*
-rw-r--r--  1 root root    47 Oct 22  2020  .user.ini
drwxr-xr-x  6 root root  4096 May 23 22:21  app/
-rwxr-xr-x  1 root root   684 May  5 11:32  composer.json*
-rwxr-xr-x  1 root root 23126 Jun 10 22:57  composer.lock*
drwxr-xr-x  2 root root  4096 Jun  6 10:35  config/
drwxr-xr-x  2 root root  4096 Apr 28 22:24  extend/
-rwxr-xr-x  1 root root   506 Apr 28 22:24  max*
drwxr-xr-x  4 root root  4096 Jun 14 10:14  public/
drwxr-xr-x  2 root root  4096 Apr 28 22:24  routes/
drwxrwxrwx  4 root root  4096 Jun 12 14:36  storage/
drwxr-xr-x  8 root root  4096 Jun 14 10:47  vendor/
drwxr-xr-x  3 root root  4096 May 18 14:05  views/
drwxr-xr-x  2 root root  4096 Jun 12 05:51 ''$'\346\226\207\346\241\243'/

```

下面介绍下一般的解决办法：

首先安装语言包

```
sudo apt-get install language-pack-zh-hans
```

安装完成后需要将我们的LANG设置为中文。

```
locale -a 
```
上面命令查看安装的语言

```
root@VM-0-10-ubuntu:/var/www/chengyao.xyz# locale -a
C
C.UTF-8
POSIX
en_US.utf8
zh_CN.utf8
zh_SG.utf8
```
接下来

```
export LANG=zh_CN.utf8
```
然后看下文件列表

```
drwxr-xr-x 11 root root  4096 6月  14 09:52 ./
drwxr-xr-x  4 root root  4096 6月  14 09:53 ../
drwxr-xr-x  2 root root  4096 6月  12 05:51 文档/
drwxr-xr-x  6 root root  4096 5月  23 22:21 app/
-rwxr-xr-x  1 root root   684 5月   5 11:32 composer.json*
-rwxr-xr-x  1 root root 23126 6月  10 22:57 composer.lock*
drwxr-xr-x  2 root root  4096 6月   6 10:35 config/
drwxr-xr-x  2 root root  4096 4月  28 22:24 extend/
-rwxr-xr-x  1 root root    18 4月  28 22:24 .htaccess*
-rwxr-xr-x  1 root root   506 4月  28 22:24 max*
drwxr-xr-x  4 root root  4096 6月  14 10:14 public/
drwxr-xr-x  2 root root  4096 4月  28 22:24 routes/
drwxrwxrwx  4 root root  4096 6月  12 14:36 storage/
-rw-r--r--  1 root root    47 10月 22  2020 .user.ini
drwxr-xr-x  8 root root  4096 6月  14 10:47 vendor/
drwxr-xr-x  3 root root  4096 5月  18 14:05 views/
```

`文档`被显示出来了。

最后我将他添加到家目录下的`.bashrc`文件里

```
export LANG=zh_CN.utf8
```

就可以一直正常显示中文了。