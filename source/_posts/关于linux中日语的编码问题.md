---
title: 关于linux中日语的编码问题
date: 2020-11-12 11:04:38
tags:
---

对于日语的编码

windows ： Shift-JIS

Linux ： 2.4内核使用EUC编码，2.6内核中使用UTF8编码

检查文件编码  nkf -g filename

通常处理字符编码都使用iconv这个命令，但是iconv命令只能用来处理文件名，但对于文本内容的编码就无法处理了，

要想对文本内容的字符编码进行转换，就要用到nkf了

-j           : 转换为 JIS 编码(ISO-2022-JP)，默认
-e           : 转换为 EUC 编码
-s           : 转换为 Shift-JIS 编码
-w           : 转换为 UTF-8 编码（无BOM）
-Lu          : 转换为 unix 换行格式(LF)
-Lw          : 转换为 windows 换行格式(CRLF)
-Lm          : 转换为 macintosh 换行格式(CR)
-g(--guess)  : 自动判断编码并显示
--version    : 显示版本
--help       : 显示帮助
linux中转换成window     ：   nkf -sxLw    nkf -swLw
window转换成linux         ：   nkf -wxLu

在vim中输入:e ++enc=utf8可以快速解决vim乱码问题，即使语言配置不正确，也可以快速解决乱码问题。

这种方式的原理是:  当vim无法识别文档的编码的时候，会使用latin-1去读取，导致文档显示上出现乱码，上述命令，就会让vim用utf-8编码的方式重新加载一遍，当然如果你的文档是用gbk编码的，可以使用: e ++=enc=gbk的方式来转换。

设置编码还可以用set encoding / set fileencoding