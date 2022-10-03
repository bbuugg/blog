---
title: linux基本命令grep egrep fgrep zgrep用法以及正则表达式
date: 2021-05-01 21:23:17
tags:
---

# 一、grep、egrep、fgrep命令

 本文中主要介绍了`linux`系统下`grep` `egrep` `fgrep`命令和正则表达式的基本参数和使用格式、方法。

<!-- more -->

## 1.1、基本定义：

> grep（global search regular RE ) and print out the line,全面搜索正则表达式并把行打印出来）是一种强大的文本搜索工具，它只能使用基本的正则表达式来搜索文本，并把匹配的行打印出来。

1. grep是很常见也很常用的命令，它的主要功能是进行字符串数据的比较，然后符合用户需求的字符串打印出来，但是主意，grep在数据中查找一个字符串时，是以“整行”为单位进行数据筛选的。

2.   egrep命令等同于grep -E，利用此命令可以使用扩展的正则表达式对文本进行搜索，并把符合用户需求的字符串打印出来。

3.   fgrep命令等同于grep -F，它利用固定的字符串来对文本进行搜索，但不支持正则表达式的引用，所以此命令的执行速度也最快。

## 1.2、命令基本用法

```
grep [option] '搜索字符串' filename
```

> grep常用选项：

```
-a :在二进制文件中，以文本文件的方式搜索数据

-c :计算找到'搜索字符串'的次数

-i :忽略大小写

-v :反向查找，即显示没有'搜索字符串'内容的那行

-o :只显示被模式匹配的字符串

-n :输出行号

--colour（color）:颜色显示
```

 
```
-A：显示匹配到字符那行的后面n行

-B：显示匹配到字符那行的前面n行

-C：显示匹配到字符那行的前后n行
```
 

# 二、正则表达式

## 2.1、基本定义：

> 正则表达使用单个字符串来描述、匹配一系列符合某个句法规则的字符串。在很多文本编辑器里，正则表达式通常被用来检索、替换那些符合某个模式的文本。简而言之，正则表达式就是处理字符串的方法，以行为单位进行字符串的处理，通过一些特殊符号的辅助，可以让用户轻松搜索/替换某特定的字符串。


正则表达式分为两类：基本的正则表达式和扩展的正则表达式。

## 2.2、正则表达式详细介绍

###  2.2.1、基本的正则表达式：

   （1）元字符：

​      . :匹配任意单个字符

​       fg：查找包含student且student后面带一个字符的行

​       grep ‘student.’ /etc/passwd （模式可以用单引号和双引号，如果模式中要做变量替换时则必须用双引）   

​      [] :匹配指定范围内的任意单个字符,[abc],[a-z],[0-9],[a-zA-Z]

​        fg：查找带有数字的行

```
grep '[0-9]' /etc/passwd
```

​      [^] :匹配指定范围外的任意单个字符

​        fg：查找没有小写字母的行。

```
grep '[^a-z]' /etc/inittab
```

`[:space:]`: 表示空白字符
`[:punct:]`: 表示所有标点符号的集合
`[:lower:]`: 表示所有的小写字母
`[:upper:]`: 表示所有的大写字母
`[:alpha:]`: 表示大小写字母
`[:digit:]`: 表示数子
`[:alnum:]`: 表示数字和大小写字母-----使用格式:alnum:等

   （2）次数匹配：

​      \*  :匹配其前面的字符任意次

​        fg：查找root出现0次或0次以上的行

```
grep 'root*' /etc/passwd
```

​      .* :任意字符 

​        fg：查找包含root的行

```
grep 'root.*' /etc/passwd
```

​      \?：匹配其前面的字符1次或0次

​      \{m,n\} :匹配其前字符最少m，最多n次）

​    (3) 字符锚定：

​      ^:锚定行首，此字符后面的任意内容必须出现在行首

​        fg：查找行首以#开头的行

​        grep '^#' /etc/inittab

​      $:锚定行尾，此字符前面的任意内容必须出现在行尾

​        fg：查找行首以root结尾的行

​        grep 'root$' /etc/inittab  

​      ^$:锚定空白行，可以统计空白行

​      \<或者\b:锚定词首，其后面的任意字符必须做为单词首部出现

​        fg:查找root且root前面不包含任何字符的行

​         grep '\

​      \>或者\b:锚定词尾，其前面的任意字符必须做为单词尾部出现             fg：\ 查找root单词  grep "\" =grep "\broot\b"

###  2.2.2、扩展的正则表达式：

​     扩展的正则表达只是在基本的正则表达上作出了小小的一点修改，其修改如下：

 在扩展的正则表达中把\( \) 写成()、\{ \} 写成{ }，另外加入了+：次数匹配，匹配其前面的字符至少出现一次，无上限、|: 或者(二取一），其余的都一样， 基本正则表达式，使用( ) { } . ? |都需要转义,在扩展正则表达中不需要加\，（这里测试了以下|是需要转义的）其详细信息如下：

​     (1) 字符匹配的命令和用法与基本正则表达式的用法相同，这里不再重复阐述。

​     (2) 次数匹配：

​       \* :匹配其前面字符的任意次

​       ？:匹配其前面字符的0此或着1此

​       \+ :匹配其前面字符至少1此

​         fg：至少一个空白符： '[[:space:]]+'

​       {m,n} :匹配其前面字符m到n次

​     (3) 字符锚定的用法和基本正则表达式的用法相同，在此不再阐述。

​     （4）特殊字符：

​        | : 代表或者的意思。

​          fg：grep -E 'c|cat' file：表示在文件file内查找包含c或者cat

​        \.:\表示转义字符，此表示符号.

# 三、grep命令利用小实例

(1)显示/etc/inittab 中以#开头，且后面跟一个或者多个空白符，而后又跟了任意非空白符的行

grep '#[[:space:]]*[^[:space:]]' /etc/inittab

(2) 输出不是数字开关的行grep '^[^0-9]'

/etc/passwd

(3)输出行首是1或2

```
grep '^\(1\|2\)' /etc/inittab
```

或

```
grep -E '^(1|2)' /etc/inittab
```

 

(4)查找前面是rc中间接任意字符而后跟/rc

 

```
grep '.*\(rc\).*\/\1.*' /etc/inittab
```

 

(5）取出当前电脑上的IP

 

```
ifconfig |grep -A 1 "^eth0" |grep "\<[0-9.]\{1,\} |cut -d: -f2
```

 

(6)查找当前系统上名字为student（必须出现在行首）的用户账户的相关信息，文件为/etc/passwd

 

```
grep "^student" /etc/passwd
```





# zgrep

[http://einverne.github.io/post/2017/11/zgrep-grep-gz-file.html](https://blog.csdn.net/weixin_40720226/article/details/90609293)

Linux 下按照正则过滤文本的命令 [grep](https://so.csdn.net/so/search?q=grep&spm=1001.2101.3001.7020) 非常强大，grep 能够把正则匹配的行打印出来。而 zgrep 则能够对压缩包内容进行正则匹配。zgrep 全称是 search compressed files for a regular expression

grep 的命令格式是

```css
grep [option] pattern files
```

他的工作方式是，在一个或者多个文件中根据正则搜索匹配内容，将搜索的结果输出到标准输出，不更改源文件内容。

## grep 常用的一些选项

```diff
-i   忽略字符大小写区别-v   显示不包含正则的所有行
```

 关于更多的 grep 的内容可以参考另外一篇文章，zgrep 和 grep 用法类似，不过操作的对象是压缩的内容。支持 bzip2，gzip，lzip， xz 等等。

## zgrep 使用

但如果想要过滤 Nginx 的 access_log.gz 的压缩文件的内容，如果先解压，然后过滤出有用的文本，再把文件压缩回去，这就变的非常不方便。

```perl
gunzip access_log.gzgrep "/api" access_loggzip access_log
```

需要使用三个命令来实现文件的过滤，其实 Linux 下可以使用 `zgrep` 来一步完成

```javascript
zgrep "/api" access_log.gz
```

和 grep 类似， `zgrep` 也可以指定多个文件同时进行搜索过滤

```javascript
zgrep "/api" access_log.gz access_log_1.gz
```

## 延伸

既然提到了不解压搜索压缩包内容，`.gz` 的文件可以使用 `zgrep` ，而对于 `.tar.gz` 文件

```perl
zcat access.tar.gz | grep -a '/api'zgrep -a "/api" access.tar.gz
```

其实这些带 `z` 的命令都包含在 Zutils 这个工具包中，这个工具包还提供了

```vbnet
zcat  解压文件并将内容输出到标准输出zcmp  解压文件并且 byte by byte 比较两个文件zdiff 解压文件并且 line by line 比较两个文件zgrep 解压文件并且根据正则搜索文件内容ztest - Tests integrity of compressed files.zupdate - Recompresses files to lzip format.
```

这些命令支持 bzip2, gzip, lzip and xz 格式。
