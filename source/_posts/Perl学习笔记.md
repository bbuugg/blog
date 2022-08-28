---
title: Perl学习笔记
date: 2021-04-02 18:42:35
tags:
---

scalar(@_)； 可以取数组长度  $a = @a; 数组大小

local 给全局变量分配临时值在局部使用

state 关键字需要使用use feture &quot;state&quot;;

使用时间转换函数需要引入

use POSIX fw(strftime);

strftime &quot;%a&quot; ,localtime;

ref可以用来判断变量的类型



使用\\$,\\@,\\%,\\*,\\&amp; 来引用，使用$, @ 或 % 来去掉引用，类似于c中的指针，引用函数只需要\\&amp;函数名即可（$cref = \\&amp;function_name），再使用引用调用函数&amp;$cref()

uc / lc 转换大小写



$param =~ s/^ *(.*?) *$/$1/ 使用正则替换，可以使用后向引用