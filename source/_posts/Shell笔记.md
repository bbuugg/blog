---
title: Shell笔记
date: 2021-04-05 22:44:57
cover: https://tse1-mm.cn.bing.net/th/id/R-C.a6e88686b0f7dda73f772fdb7ea5eb38?rik=WywAPm%2fgbGJvEA&riu=http%3a%2f%2ffullhdpictures.com%2fwp-content%2fuploads%2f2016%2f06%2fShell-Logo-Wallpaper.jpg&ehk=09BEzQavZ8lju%2bU3VS6B75zB6yVgP%2fauUO%2fr1VvVTXU%3d&risl=&pid=ImgRaw&r=0
tags:
---

#let
> let 命令是 BASH 中用于计算的工具，用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量。如果表达式中包含了空格或其他特殊字符，则必须引起来。

```shell
let arg [arg ...]
```

<!-- more -->

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

# shell中的2>&1

## A.首先了解下1和2在Linux中代表什么

在Linux系统中0 1 2是一个文件描述符

| 名称                 | 代码 | 操作符           | Java中表示 | Linux 下文件描述符（Debian 为例)             |
| -------------------- | ---- | ---------------- | ---------- | -------------------------------------------- |
| 标准输入(stdin)      | 0    | < 或 <<          | System.in  | /dev/stdin -> /proc/self/fd/0 -> /dev/pts/0  |
| 标准输出(stdout)     | 1    | >, >>, 1> 或 1>> | System.out | /dev/stdout -> /proc/self/fd/1 -> /dev/pts/0 |
| 标准错误输出(stderr) | 2    | 2> 或 2>>        | System.err | /dev/stderr -> /proc/self/fd/2 -> /dev/pts/0 |

上面表格引用自[这里](https://yanbin.blog/linux-input-output-redirection/)
从上表看的出来，我们平时使用的

```shell
echo "hello" > t.log
```


其实也可以写成

```shell
echo "hello" 1> t.log
```

# B.关于2>&1的含义

（关于输入/输出重定向本文就不细说了，不懂的可以参考这里，主要是要了解> < << >> <& >& 这6个符号的使用）

含义：将标准错误输出重定向到标准输出
符号>&是一个整体，不可分开，分开后就不是上述含义了。
比如有些人可能会这么想：2是标准错误输入，1是标准输出，>是重定向符号，那么"将标准错误输出重定向到标准输出"是不是就应该写成"2>1"就行了？是这样吗？
如果是尝试过，你就知道2>1的写法其实是将标准错误输出重定向到名为"1"的文件里去了
写成2&>1也是不可以的
C.为什么2>&1要放在后面
考虑如下一条shell命令

```
nohup java -jar app.jar >log 2>&1 &
```


(最后一个&表示把条命令放到后台执行，不是本文重点，不懂的可以自行Google)
为什么2>&1一定要写到>log后面，才表示标准错误输出和标准输出都定向到log中？
我们不妨把1和2都理解是一个指针,然后来看上面的语句就是这样的：

1. 本来1----->屏幕 （1指向屏幕）
2. 执行>log后， 1----->log (1指向log)
3. 执行2>&1后， 2----->1 (2指向1，而1指向log,因此2也指向了log)

再来分析下

```shell
nohup java -jar app.jar 2>&1 >log &
```

1. 本来1----->屏幕 （1指向屏幕）
2. 执行2>&1后， 2----->1 (2指向1，而1指向屏幕,因此2也指向了屏幕)
3. 执行>log后， 1----->log (1指向log，2还是指向屏幕)

所以这就不是我们想要的结果。
**简单做个试验测试下上面的想法**：
java代码如下：

```java
public class Htest {
    public static void main(String[] args) {
        System.out.println("out1");
        System.err.println("error1");
    }
}
```



javac编译后运行下面指令：

```
java Htest 2>&1 > log
```



你会在终端上看到只输出了"error1"，log文件中则只有"out1"

D.每次都写">log 2>&1"太麻烦，能简写吗？
有以下两种简写方式

```
&>log

&log
```



比如上面小节中的写法就可以简写为：

```
nohup java -jar app.jar &>log &
```
 

上面两种方式都和`>log 2>&1`一个语义。
那么 上面两种方式中&>和>&有区别吗？
**语义上是没有任何区别的，但是第一中方式是最佳选择，一般使用第一种**

# 输出带颜色字体


输出特效格式控制：*
\033[0m*  关闭所有属性 *
\033[1m*  设置高亮度 *
\03[4m*  下划线 *
\033[5m*  闪烁 *
\033[7m*  反显 *
\033[8m*  消隐 *
\033[30m  --  \033[37m*  设置前景色 *
\033[40m  --  \033[47m*  设置背景色



光标位置等的格式控制：
\033[nA  光标上移n行  
\03[nB  光标下移n行  
\033[nC  光标右移n行  
\033[nD  光标左移n行  
\033[y;xH设置光标位置  
\033[2J  清屏  
\033[K  清除从光标到行尾的内容  
\033[s  保存光标位置  
\033[u  恢复光标位置  
\033[?25l  隐藏光标  

\33[?25h  显示光标

整理：
  编码 颜色/动作
　　0  重新设置属性到缺省设置
　　1  设置粗体
　　2  设置一半亮度(模拟彩色显示器的颜色)
　　4  设置下划线(模拟彩色显示器的颜色)
　　5  设置闪烁
　　7  设置反向图象
　　22 设置一般密度
　　24 关闭下划线
　　25 关闭闪烁
　　27 关闭反向图象
　　30 设置黑色前景
　　31 设置红色前景
　　32 设置绿色前景
　　33 设置棕色前景
　　34 设置蓝色前景
　　35 设置紫色前景
　　36 设置青色前景
　　37 设置白色前景
　　38 在缺省的前景颜色上设置下划线
　　39 在缺省的前景颜色上关闭下划线
　　40 设置黑色背景
　　41 设置红色背景
　　42 设置绿色背景
　　43 设置棕色背景
　　44 设置蓝色背景
　　45 设置紫色背景
　　46 设置青色背景
　　47 设置白色背景
　　49 设置缺省黑色背景
特效可以叠加，需要使用“;”隔开，例如：闪烁+下划线+白底色+黑字为  \033[5;4;47;30m闪烁+下划线+白底色+黑字为\033[0m
下面是一段小例子



```bash
#!/bin/bash
#
#下面是字体输出颜色及终端格式控制
#字体色范围：30-37
echo -e "\033[30m 黑色字 \033[0m"
echo -e "\033[31m 红色字 \033[0m"
echo -e "\033[32m 绿色字 \033[0m"
echo -e "\033[33m 黄色字 \033[0m"
echo -e "\033[34m 蓝色字 \033[0m"
echo -e "\033[35m 紫色字 \033[0m"
echo -e "\033[36m 天蓝字 \033[0m"
echo -e "\033[37m 白色字 \033[0m"
#字背景颜色范围：40-47
echo -e "\033[40;37m 黑底白字 \033[0m"
echo -e "\033[41;30m 红底黑字 \033[0m"
echo -e "\033[42;34m 绿底蓝字 \033[0m"
echo -e "\033[43;34m 黄底蓝字 \033[0m"
echo -e "\033[44;30m 蓝底黑字 \033[0m"
echo -e "\033[45;30m 紫底黑字 \033[0m"
echo -e "\033[46;30m 天蓝底黑字 \033[0m"
echo -e "\033[47;34m 白底蓝字 \033[0m"

#控制选项说明
#\033[0m 关闭所有属性
#\033[1m 设置高亮度
#\033[4m 下划线
echo -e "\033[4;31m 下划线红字 \033[0m"
#闪烁
echo -e "\033[5;34m 红字在闪烁 \033[0m"
#反影
echo -e "\033[8m 消隐 \033[0m "

#\033[30m-\033[37m 设置前景色
#\033[40m-\033[47m 设置背景色
#\033[nA光标上移n行
#\033[nB光标下移n行
echo -e "\033[4A 光标上移4行 \033[0m"
#\033[nC光标右移n行
#\033[nD光标左移n行
#\033[y;xH设置光标位置
#\033[2J清屏
#\033[K清除从光标到行尾的内容
echo -e "\033[K 清除光标到行尾的内容 \033[0m"
#\033[s 保存光标位置
#\033[u 恢复光标位置
#\033[?25| 隐藏光标
#\033[?25h 显示光标
echo -e "\033[?25l 隐藏光标 \033[0m"
echo -e "\033[?25h 显示光标 \033[0m"
```