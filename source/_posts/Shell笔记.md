---
title: Shell笔记
date: 2021-04-05 22:44:57
tags:
---

#let
>let 命令是 BASH 中用于计算的工具，用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量。如果表达式中包含了空格或其他特殊字符，则必须引起来。

```shell
let arg [arg ...]
```
## 实例：
自加操作：`let no++`

自减操作：`let no--`

简写形式 `let no+=10`，`let no-=20`，分别等同于 `let no=no+10`，`let no=no-20`。

以下实例计算 a 和 b 两个表达式，并输出结果：

```shell
#!/bin/bash
let a=5+4
let b=9-3 
echo $a $b
```

上条命令执行成功
```
if [ $? -eq 0 ]; then
	echo "OK"
fi
```

```shell
-s file　　　　　文件大小非0时为真
[ -f "somefile" ] ：判断是否是一个文件

[ -x "/bin/ls" ] ：判断/bin/ls是否存在并有可执行权限

[ -n "$var" ] ：判断$var变量是否有值

[ "$a" = "$b" ] ：判断$a和$b是否相等 

-r file　　　　　用户可读为真

-w file　　　　　用户可写为真

-x file　　　　　用户可执行为真

-f file　　　　　文件为正规文件为真

-d file　　　　　文件为目录为真

-c file　　　　　文件为字符特殊文件为真

-b file　　　　　文件为块特殊文件为真

-s file　　　　　文件大小非0时为真　　　　-s file true if the file has nonzero size

-t file　　　　　当文件描述符(默认为1)指定的设备为终端时为真

 

-a file exists.
-b file exists and is a block special file.
-c file exists and is a character special file.
-d file exists and is a directory.
-e file exists (just the same as -a).
-f file exists and is a regular file.
-g file exists and has its setgid(2) bit set.
-G file exists and has the same group ID as this process.
-k file exists and has its sticky bit set.
-L file exists and is a symbolic link.
-n string length is not zero.
-o Named option is set on.
-O file exists and is owned by the user ID of this process.
-p file exists and is a first in, first out (FIFO) special file or
named pipe.
-r file exists and is readable by the current process.
-s file exists and has a size greater than zero.
-S file exists and is a socket.
-t file descriptor number fildes is open and associated with a
terminal device.
-u file exists and has its setuid(2) bit set.
-w file exists and is writable by the current process.
-x file exists and is executable by the current process.
-z string length is zero.
```

**shell判断字符串为空的方法**

Linux 下判断字符串是否为空，可以使用两个参数：

● -z ：判断 string 是否是空串

● -n ：判断 string 是否是非空串

例子：

```
#!/bin/sh`` ` `STRING=`` ` `if` `[ -z ``"$STRING"` `]; then`` ``echo` `"STRING is empty"``fi`` ` `if` `[ -n ``"$STRING"` `]; then`` ``echo` `"STRING is not empty"``fi`` ` `root@desktop:~# ./zerostring.sh ``STRING is ``empty
```

注：在进行字符串比较时， 用引号将字符串界定起来 ，是一个非常好的习惯！

其他方法：

```
if` `[ ``"$str"` `= ``""` `]
```

