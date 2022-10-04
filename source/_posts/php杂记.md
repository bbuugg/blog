---
title: php杂记
date: 2020-08-15 07:19:58
tags:
categories: php
---

#### 查看端口

```
netstat -tunlp | grep 端口号`
`lsof -i:端口号
```

<!-- more -->

#### 重启nginx

```
nginx -s reload`
`service nginx restart
```

#### 查找文件

```
find / -name filename
```

#### 解压

```
tar zxvf filename
```

#### 过滤查找

```
cmd |grep findname
```

#### 重命名文件夹

```
mv old_filename new_filename
```

#### 查找程序

```
ps -aux | grep name
```

#### 重启服务

```
service servicename restart
```

#### 修改文件权限

```
chmod 777 filename
```

#### 添加新用户

`adduser username`
`-d path`绑定当前用户的访问目录
`passwd username`给用户更新或添加密码

#### vsftpd新增用户

先同上新增一个访问受限用户，再去vsftpd安装目录下修改数个配置文件，有用户文件，有访问权限文件，以及一个用户配置文件，还需要在指定目录处建立一个同名目录。

#### git操作

初始化仓库：
先添加用户 `adduser git`
创建证书登录 `/home/git/.ssh/authorized_keys`
创建仓库 `git init --bare name.git`

### 杂项

swoole提供网络服务时需要单独占用一个端口来提供服务

### docker

`doker pull imagename`下载一个镜像
`docker run imagename`运行容器
`-p 主机端口：容器端口` 运行参数之绑定端口
`-i`交互式运行 `-t`终端式运行 `-d`后台式运行
`-name`给容器命名，方便后续使用
`docker ps`查看运行中的容器
`docker kill containername`停掉运行中的容器

### php添加新扩展

先使用wget下载文件
使用phpize生成配置文件
使用./configure生成编译文件
make && make install
之后在php.ini中添加扩展，再在conf.d中加入指向so文件的地址

### 一次thinkphp源码修改

原因 php7.3后 strpos 返回值做了修改
原：
`if (strpos($url , $bind)===0)` Url.php下
修改后：
`if ($bind && strpos($url , $bind ) ===0 )`

#### php7.4

implode 参数修改为分隔符在前，数组在后

### 原生js的关联数据

使用 hash 传递关联数据，使用`JSON.stringify( )`将 hash 对象转为 json 字符串

后端 php 拿到数据后 使用 `json_decode()`进行 json 解码，但得到的仍为对象

#### ps

ps 用于查看当前运行的进程。

ps aux 和 ps -ef

两者的输出结果差别不大，但展示风格不同。aux是BSD风格，-ef是System V风格。

主要区别是，aux会截断command列，而-ef不会，当结合grep时这种区别会影响到结果

#### netstat

用于打印网络连接、路由表、连接的数据统计、伪装连接以及广播域成员

常见用法 netstat -tulp

#### top

用于实时查看服务器进程等信息

#### char与varchar

char : 定长，效率高，一般用于固定商都的表单提交数据存储
varchar : 不定长，效率偏低
使用 Innodb 引擎的话，使用varchar代替char

#### sort uniq命令排序 去重

uniq 命令可以显示文件中行重复的次数，或只显示出现一次的行，或仅仅显示重复出现的行；但uniq 的去重针对的只是连续的两行

```
sort filename | uniq -c
```

-c 用来在每一行最前面加上该行出现的次数

-u 只显示出现一次的行

-d 只显示重复出现的行

#### error_reporting

设置应该报告何种PHP错误

```
error_reporting ( [ int $level ] ) : int
```

#### 类中调用同一类中的其他静态资源，可使用`static::name`来代替`classname::name`

#### self static

self调用静态方法或属性，可能会升级为父类中的数据

static调用只会涉及当前之类中数据，不会发生升级现象

#### self、this、parent

this指向当前对象的指针

self指向当前类的指针

parent指向父类的指针

#### php的初始化方法只有构造方法，其他的都为包装过的构造方法

------

#### 数组相关

`array_merge` 合并数组，返回值为合并后数组
`array_diff` 求数组差集，只比较键值，返回值为差集数组
`array_intersect` 求数组并集，只比较键值，返回值为并集数组
http://blog.kaiot.xyz/read/56.html