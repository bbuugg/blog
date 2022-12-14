---
title: Linux下使用Vim常用的一些命令
date: 2021-03-30 10:21:47
tags:
---

## 方法一 ：块选择模式

批量注释：

Ctrl + v 进入块选择模式，然后移动光标选中你要注释的行，再按大写的I进入行首插入模式输入注释符号如 // 或 #，输入完毕之后，按两下ESC，Vim会自动将你选中的所有行首都加上注释，保存退出完成注释。

<!-- more -->

取消注释：

Ctrl + v 进入块选择模式，选中你要删除的行首的注释符号，注意// 要选中两个，选好之后按d即可删除注释，ESC保存退出。

## 方法二 替换命令

批量注释：

使用下面命令在指定的行首添加注释：

:起始行号,结束行号s/^/注释符/g

取消注释：

:起始行号,结束行号s/^注释符//g

例子：

在10 - 20行添加 // 注释

:10,20s#^#//#g

在10 - 20行删除 // 注释

:10,20s#^//##g

 

在10 - 20行添加 # 注释

:10,20s/^/#/g

在10 - 20行删除 # 注释

:10,20s/^/#/g

> 注意：替换方法的例子中正则的分割符使用的是相反的符号，如果匹配// 那么使用 #作分隔符这样不需要对/作转义处理，节省输入次数。

```
:s/return/ret/g
:%s/return/ret/g
```

# 快速清空文件

```
gg # 跳到行首
dG # 删除直到末尾
```



# 缩进
行首
```
ctrl + v
```
按向下箭头选中行，按 > 或者 < 调整缩进

# 括号寻找

```
public function index() {

}
```
光标移动到第一个括号位置，按下%将跳到相应的闭合括号位置


# 批量删除

## 删除后原位置留空
```shell
ctrl + v 
上下左右箭头选中
按下D
```
## 删除后内容上移
```shell
ctrl + v 
上下左右箭头选中
按下:d 或者:%d
```

# 格式化

```shell
gg
ctrl + v 
G 
=
```

或者
```shell
gg=G
```

缩进
```shell
:10,100< //将10到100行向左缩进
```
可以使用`:set shiftwidth = 2`设置缩进，也可以放在`.vimrc`中

# 删除一个单词
通常要先将光标移动到单词头部，在末行模式按下`b`即可，再按下`dw`即可删除。或者直接输入`daw`删除单词。另外还有一个删除字符`x`可以在末行模式使用

# 删除光标后的内容
直接`D`

# 剪切内容，下面的内容上移
`v` / `ctrl + v` 选中
`:d` 回车
`p` 粘贴

# 单词间移动
`w`/`e` 后， `b`前

# vim 折行

## 折叠方式

可用选项 'foldmethod' 来设定折叠方式：set fdm=*****。
有 6 种方法来选定折叠：

```
manual       手工定义折叠
indent       更多的缩进表示更高级别的折叠
expr         用表达式来定义折叠
syntax       用语法高亮来定义折叠
diff         对没有更改的文本进行折叠
marker       对文中的标志折叠
```

> 注意，每一种折叠方式不兼容，如不能即用expr又用marker方式，我主要轮流使用indent和marker方式进行折叠。

使用时，用：set fdm=marker 命令来设置成marker折叠方式（fdm是foldmethod的缩写）。
要使每次打开vim时折叠都生效，则在.vimrc文件中添加设置，如添加：set fdm=syntax，就像添加其它的初始化设置一样。

## 折叠命令

选取了折叠方式后，我们就可以对某些代码实施我们需要的折叠了，由于我使用indent和marker稍微多一些，故以它们的使用为例：
如果使用了indent方式，vim会自动的对大括号的中间部分进行折叠，我们可以直接使用这些现成的折叠成果。
在可折叠处（大括号中间）：

```
zc    折叠
zC    对所在范围内所有嵌套的折叠点进行折叠
zo    展开折叠
zO    对所在范围内所有嵌套的折叠点展开
[z    到当前打开的折叠的开始处。
]z    到当前打开的折叠的末尾处。
zj    向下移动。到达下一个折叠的开始处。关闭的折叠也被计入。
zk    向上移动到前一折叠的结束处。关闭的折叠也被计入。
```

当使用marker方式时，需要用标计来标识代码的折叠，系统默认是`{{{`和`}}}`，最好不要改动之：）
我们可以使用下面的命令来创建和删除折叠：

```
zf     创建折叠，比如在marker方式下： zf56G，创建从当前行起到56行的代码折叠； 10zf或10zf+或zf10↓，创建从当前行起到后10行的代码折叠。 10zf-或zf10↑，创建从当前行起到之前10行的代码折叠。 在括号处zf%，创建从当前行起到对应的匹配的括号上去（（），{}，[]，<>等）。
zd     删除 (delete) 在光标下的折叠。仅当 'foldmethod' 设为 "manual" 或 "marker" 时有效。
zD     循环删除 (Delete) 光标下的折叠，即嵌套删除折叠。 仅当 'foldmethod' 设为 "manual" 或 "marker" 时有效。
zE     除去 (Eliminate) 窗口里“所有”的折叠。 仅当 'foldmethod' 设为 "manual" 或 "marker" 时有效。
```

# 查看/修改十六进制或者二进制文件等

```
hexdump a.txt
```

```
xxd a.txt
```

```
vim -b a.txt
```

xxd是linux的一个命令，vim可以通过”!”来调用外部命令，其功能就是进行十六进制的dump或者反之。
```
:%!od 
:%!xxd
:%!xxd -r 16进制转为2进制
```

参考：http://blog.chinaunix.net/uid-29767867-id-4413135.html
推荐：https://blog.csdn.net/xxxxxx91116/article/details/8042312


## 执行shell脚本报错/usr/bin/env: ‘bash\r’: No such file or directory

主要原因是*.sh是在windows下编辑然后上传到linux系统里执行的。.sh文件的格式为dos格式。而linux只能执行格式为unix格式的脚本。

```shell
vim release.sh
:set ff # 查看fileformat 应该是dos
:set ff=unix # 设置为unix
:wq
```

## 统计关键词出现的次数

```shell
:%s/keyword/gn
```

参数说明：

- % - 指明操作区间，%表示全文本；可以使用1,$或者行区间代替
- s – substitute，表示替换
- pattern - 要查找的字符串
- // - 替代文本应该放在这里，两个斜杠中间没有任何字符表示无替代文本
- g – Replace all occurences in the line. Without this argument, replacement occurs only for the first occurence - in each line.
- n – Report the number of matches, and do not actually substitute. 这是核心功能，同时也说明为什么//之间可以添加任意字符。
 
一些引申出的应用：

(1) :k,ls/pattern//gn
统计k行到l行出现pattern的次数
(2) :%s/pattern//gn
统计在当前编辑文本出现的次数
(3) cat file|greg –i pattern |wc –l
统计在文件中出现的行数