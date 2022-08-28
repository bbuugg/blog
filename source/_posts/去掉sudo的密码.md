---
title: 去掉sudo的密码
date: 2021-10-20 22:42:36
tags:
---

sudo执行命令的时候老是让输入密码，真的好烦，下面为去掉密码的方法：

首先打开/etc/sudoers

"sudo visudo" 或 “sudo vi /etc/sudoers”

建议用以下命令打开"sudo visudo"，用该命令编辑sudoers后保存时如果有语法错误系统会给出提示，而用“vi /etc/sudoers”就不会给出错误提示。

内容如下：
```shell
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL

# See sudoers(5) for more information on "#include" directives:
```

接下来有二种方法(以下操作必须谨慎，使用出错与小站无关)

方法一：

找到 `%admin ALL=(ALL) ALL`这一行，将其修改为 `%admin ALL=(ALL) NOPASSWD:ALL`，或者直接给`sudo`加上`NOPASSWD`，如上代码
方法二：

在`%admin ALL=(ALL) ALL`这一行的下面添加一行 `username ALL = NOPASSWD:ALL`

一定要在`%admin ALL=(ALL) ALL`行的下面，否则系统会先加载`username ALL = NOPASSWD:ALL”再加载“%admin ALL=(ALL) ALL`

由于username属于admin组所以会将对username的设置覆盖。

注：username是你登录的用户名。

顺便附加一个介绍sudo的博客：https://blog.csdn.net/zahuopuboss/article/details/8909891