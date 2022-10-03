---
title: Linux下登录Oracle命令行时删除键^H解决方法
date: 2021-04-04 15:19:36
tags:
---

在linux服务器下登录oracle的控制台，如果输入错误，想用删除键删除时却不能删除，打出的是^H的字符。

#### **方法1：**

用如下的命令可以使删除键生效：

```
$ stty erase ^H1
```

<!-- more -->

恢复以前的设置的命令是：

```
$ stty erase ^？1
```

#### **方法2：**

利用rlwrap工具解决：

1、安装rlwrap和readline库

CentOS下可以用EPEL的yum源直接安装，步骤如下：

（1）RHEL/CentOS/SL Linux 6.x 下安装 EPEL6 yum源：

32位系统选择：

```
# rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm1
```

64位系统选择：

```
# rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm1
```

导入key：

```
# rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-61
```

默认会在/etc/yum.repos.d/下创建epel.repo和epel-testing.repo两个配置文件。

（2）安装rlwrap和readline：

```
# yum install rlwrap readline readline-devel1
```

其他Linux发行版如果源里没有rlwrap和readline的（如SUSE企业版默认没有这两个包），要分别下载这两个源码包编译安装一下。

```
# wget ftp://ftp.gnu.org/gnu/readline/readline-6.2.tar.gz
# tar zxvf readline-6.2.tar.gz
# cd readline-6.2/
# ./configure
# make
# make install


# wget http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.37.tar.gz
# tar zxvf rlwrap-0.37.tar.gz
# cd rlwrap-0.37/
# ./configure
# make
# make install1234567891011121314
```

（3）设置sqlplus的系统别名：

```
# vim /home/oracle/.bash_profile1
```

在头部或尾部添加：

```
alias sqlplus='rlwrap sqlplus'
alias rman='rlwrap rman'12
```

退出oracle用户再重新登录就ok了。