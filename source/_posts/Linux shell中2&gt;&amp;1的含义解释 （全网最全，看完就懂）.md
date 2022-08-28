---
title: Linux shell中2&gt;&amp;1的含义解释 （全网最全，看完就懂）
date: 2021-03-01 22:11:21
tags:
---

# A.首先了解下1和2在Linux中代表什么

在Linux系统中0 1 2是一个文件描述符

| 名称                 | 代码 | 操作符           | Java中表示 | Linux 下文件描述符（Debian 为例)             |
| -------------------- | ---- | ---------------- | ---------- | -------------------------------------------- |
| 标准输入(stdin)      | 0    | &lt; 或 &lt;&lt;          | System.in  | /dev/stdin -&gt; /proc/self/fd/0 -&gt; /dev/pts/0  |
| 标准输出(stdout)     | 1    | &gt;, &gt;&gt;, 1&gt; 或 1&gt;&gt; | System.out | /dev/stdout -&gt; /proc/self/fd/1 -&gt; /dev/pts/0 |
| 标准错误输出(stderr) | 2    | 2&gt; 或 2&gt;&gt;        | System.err | /dev/stderr -&gt; /proc/self/fd/2 -&gt; /dev/pts/0 |

上面表格引用自[这里](https://yanbin.blog/linux-input-output-redirection/)
从上表看的出来，我们平时使用的

```shell
echo &quot;hello&quot; &gt; t.log
```


其实也可以写成

```shell
echo &quot;hello&quot; 1&gt; t.log
```

# B.关于2&gt;&amp;1的含义

（关于输入/输出重定向本文就不细说了，不懂的可以参考这里，主要是要了解&gt; &lt; &lt;&lt; &gt;&gt; &lt;&amp; &gt;&amp; 这6个符号的使用）

含义：将标准错误输出重定向到标准输出
符号&gt;&amp;是一个整体，不可分开，分开后就不是上述含义了。
比如有些人可能会这么想：2是标准错误输入，1是标准输出，&gt;是重定向符号，那么&quot;将标准错误输出重定向到标准输出&quot;是不是就应该写成&quot;2&gt;1&quot;就行了？是这样吗？
如果是尝试过，你就知道2&gt;1的写法其实是将标准错误输出重定向到名为&quot;1&quot;的文件里去了
写成2&amp;&gt;1也是不可以的
C.为什么2&gt;&amp;1要放在后面
考虑如下一条shell命令

```
nohup java -jar app.jar &gt;log 2&gt;&amp;1 &amp;
```


(最后一个&amp;表示把条命令放到后台执行，不是本文重点，不懂的可以自行Google)
为什么2&gt;&amp;1一定要写到&gt;log后面，才表示标准错误输出和标准输出都定向到log中？
我们不妨把1和2都理解是一个指针,然后来看上面的语句就是这样的：

1. 本来1-----&gt;屏幕 （1指向屏幕）
2. 执行&gt;log后， 1-----&gt;log (1指向log)
3. 执行2&gt;&amp;1后， 2-----&gt;1 (2指向1，而1指向log,因此2也指向了log)

再来分析下

```shell
nohup java -jar app.jar 2&gt;&amp;1 &gt;log &amp;
```

1. 本来1-----&gt;屏幕 （1指向屏幕）
2. 执行2&gt;&amp;1后， 2-----&gt;1 (2指向1，而1指向屏幕,因此2也指向了屏幕)
3. 执行&gt;log后， 1-----&gt;log (1指向log，2还是指向屏幕)

所以这就不是我们想要的结果。
**简单做个试验测试下上面的想法**：
java代码如下：

```java
public class Htest {
    public static void main(String[] args) {
        System.out.println(&quot;out1&quot;);
        System.err.println(&quot;error1&quot;);
    }
}
```



javac编译后运行下面指令：

```
java Htest 2&gt;&amp;1 &gt; log
```



你会在终端上看到只输出了&quot;error1&quot;，log文件中则只有&quot;out1&quot;

D.每次都写&quot;&gt;log 2&gt;&amp;1&quot;太麻烦，能简写吗？
有以下两种简写方式

```
&amp;&gt;log

&amp;log
```



比如上面小节中的写法就可以简写为：

```
nohup java -jar app.jar &amp;&gt;log &amp;
```



上面两种方式都和`&gt;log 2&gt;&amp;1`一个语义。
那么 上面两种方式中&amp;&gt;和&gt;&amp;有区别吗？
**语义上是没有任何区别的，但是第一中方式是最佳选择，一般使用第一种**

参考：
https://unix.stackexchange.com/questions/89386/what-is-symbol-and-in-unix-linux
https://superuser.com/questions/335396/what-is-the-difference-between-and-in-bash
————————————————
版权声明：本文为CSDN博主「一个行走的民」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/zhaominpro/article/details/82630528