---
title: 正则表达式匹配"非"，以及"非"字符串的匹配
date: 2021-04-04 15:20:54
tags:
---

#写法介绍
首先，正则表达式的"非"，代表不想匹配某个字符。
比如字符串 helloword123，/[^0-9]+/g 可以匹配非数字，即匹配结果为 helloword；

<!-- more -->

同样的，/[^he]+/g 可以匹配非h非e的字符，匹配结果为lloword123；

那么 /[^hello]/g 呢？乍一看可能会以为能匹配word123，其实不然，[^] 内的多个字符是"或"的关系存在的，即它们并不是一个整体，/[^hello]/g 表示 非h非e非l非o，并不能理解为 非(hello)，所以匹配结果是 w 和 rd123。

道理我们都懂，可我们就是想匹配非某个字符串呢？比如某一字符串若是含有hello则无匹配，若是不含hello则匹配，写成[^hello]是显然不行的，[^(hello)] 呢？其实不起作用。

这时我们需要用到正则表达式的断言——(?!pattern) 零宽负向先行断言 或者 (?&lt;!pattern) 零宽负向后行断言 均可。

这里只介绍一种写法，大家可以都去尝试一下。

```
/^((?!hello).)+$/
```

由于断言 (?!hello)是不占位的，后跟的 . 在原位置匹配任意字符，再用括号将其括起来，用+重复一次或多次，前后加上^和$，若是字符串中存在hello，则匹配到h字符之前的时候，断言(?!hello)匹配失败，正则匹配结果为false， 若是字符串中不存在hello，则匹配结果是整个字符串。

#用法实战

##匹配&和;之间不含有test的字符

```
str = "hello&nbsp;&test1;test"";
```

正则表达式：`/&((?!test).)+;/g`

匹配结果：`&nbsp;` 和 `"`

## 匹配不含有`&lt;img&gt;`标签的`&lt;div&gt;&lt;/div&gt;`标签

```
str = "&lt;div id='1'&gt;&lt;img class='xx'&gt;&lt;/div&gt;&lt;div id='1'&gt;&lt;input type=''text"&gt;&lt;/div&gt;";
```

正则表达式：` /&lt;div[^&gt;]*&gt;((?!&lt;img[^&gt;]*&gt;).)+&lt;/div&gt;/g`

匹配结果：`&lt;div id='1'&gt;&lt;input type=''text"&gt;&lt;/div&gt;`