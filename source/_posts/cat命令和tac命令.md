---
title: cat命令和tac命令
date: 2021-04-05 23:20:07
tags:
---

# cat命令

&gt;连接文件并打印到标准输出设备上，cat经常用来显示文件的内容。

注意：当文件较大时，文本在屏幕上迅速闪过（滚屏），用户往往看不清所显示的内容。因此，一般用more等命令分屏显示。

为了控制滚屏，可以按Ctrl+S键，停止滚屏；按Ctrl+Q键可以恢复滚屏。按Ctrl+C（中断）键可以终止该命令的执行，并且返回Shell提示符状态。

- -n或-number：有1开始对所有输出的行数编号；

- -b或--number-nonblank：和-n相似，只不过对于空白行不编号；

- -s或--squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行；

- -A：显示不可打印字符，行尾显示“$”；

- -e：等价于&quot;-vE&quot;选项；

- -t：等价于&quot;-vT&quot;选项；

##从键盘创建一个文件

$ cat &gt; d.txt

##将几个文件合并为一个文件

$ cat c.txt d.txt &gt; e.txt

##显示一个文件的内容

$ cat e.txt

显示多个文件的内容

$ cat e.txt a.txt

对所有输出行编号

$ cat  -n e.txt

对非空输出行编号

$ cat -b e.txt

如果有连续两行以上的空白行，输出时只显示一行

$ cat -s e.txt

显示不可打印字符，输出时每行结尾会加上一个$

$ cat -A e.txt

将一个文件的内容加上行号后输入到另一个文件里（直接覆盖掉这个文件原来的内容）

$ cat -n e.txt &gt; a.txt

将一个文件的内容加上行号后输入到另一个文件里（在尾部追加）

$ cat -n e.txt &gt;&gt; a.txt

复制这个文件

$ cat  e.txt &gt; a.txt 

合并几个文件，并且test4是已经排好序的

$ cat test test1 test2 test3 | sort &gt; test4

如果有大量的文件包含不适合在输出端子和屏幕滚动起来非常快，我们可以多和少用参数与cat命令如上表演。

$ cat e.txt | more

$ cat e.txt | less

# tac命令

反序输出文件的内容，文件的最后一行显示在第一行

它可以对调试日志文件提供了很大的帮助，扭转日志内容的时间顺序。

$ tac e.txt