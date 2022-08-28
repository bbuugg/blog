---
title: Linux 里的 2&gt;&amp;1 究竟是什么
date: 2020-11-19 09:40:18
tags:
---

我们在Linux下经常会碰到`nohup command&gt;/dev/null 2&gt;&amp;1 &amp;`这样形式的命令。首先我们把这条命令大概分解下：

- 首先就是一个`nohup`：表示当前用户和系统的会话下的进程忽略响应HUP消息。
- &amp;是把该命令以后台的job的形式运行。
- command&gt;/dev/null较好理解，/dev/null表示一个空设备，就是说把 command 的执行结果重定向到空设备中，说白了就是不显示任何信息。

&gt; 可以把/dev/null 可以看作”黑洞”。它等价于一个只写文件。所有写入它的内容都会永远丢失，而尝试从它那儿读取内容则什么也读不到。

那么2&gt;&amp;1又是什么含义?

------

**几个基本符号及其含义：**

- /dev/null 表示空设备文件；
- 0 表示stdin标准输入；
- 1 表示stdout标准输出；
- 2 表示stderr标准错误。

------

**从`command&gt;/dev/null`说起**

其实这条命令是一个缩写版，对于一个重定向命令，肯定是`a &gt; b`这种形式，那么`command &gt; /dev/null`难道是command 充当 a 的角色，`/dev/null` 充当 b 的角色。这样看起来比较合理，其实一条命令肯定是充当不了 a，肯定是 command 执行产生的输出来充当 a，其实就是标准输出 stdout。所以`command &gt; /dev/null`相当于执行了`command 1 &gt; /dev/null`。执行 command 产生了标准输出 stdout（用1表示），重定向到`/dev/null`的设备文件中。

------

**说说 `2&gt;&amp;1`**

通过上面`command &gt; /dev/null`等价于`command 1 &gt; /dev/null`，那么对于`2&gt;&amp;1`也就好理解了，2就是标准错误，1是标准输出，那么这条命令不就是相当于把标准错误重定向到标准输出么。

------

**`2&gt;1`和`2&gt;&amp;1`的写法有什么区别：**

- `2&gt;1`的作用是把标准错误的输出重定向到1，但这个1不是标准输出，而是一个文件!!!,文件名就是1；
- `2&gt;&amp;1`的作用是把标准错误的输出重定向到标准输出1，&amp;指示不要把1当作普通文件，而是fd=1即标准输出来处理。

------

**`command&gt;a 2&gt;a` 与 `command&gt;a 2&gt;&amp;1`的区别**

通过上面的分析，对于`command&gt;a 2&gt;&amp;1`这条命令，等价于`command 1&gt;a 2&gt;&amp;1`可以理解为执行 command 产生的标准输入重定向到文件 a 中，标准错误也重定向到文件 a 中。那么是否就说`command 1&gt;a 2&gt;&amp;1`等价于`command 1&gt;a 2&gt;a`呢。其实不是，`command 1&gt;a 2&gt;&amp;1`与`command 1&gt;a 2&gt;a`还是有区别的，区别就在于前者只打开一次文件a，后者会打开文件两次，并导致 stdout 被 stderr 覆盖。`&amp;1`的含义就可以理解为用标准输出的引用，引用的就是重定向标准输出产生打开的 a。从IO效率上来讲，`command 1&gt;a 2&gt;&amp;1`比`command 1&gt;a 2&gt;a`的效率更高。

------

**为何2&gt;&amp;1要写在后面？**

index.php task testOne &gt;/dev/null 2&gt;&amp;1

我们可以理解为，左边是标准输出，好，现在标准输出直接输入到`/dev/null`中，而`2&gt;&amp;1`是将标准错误重定向到标准输出，所以当程序产生错误的时候，相当于错误流向左边，而左边依旧是输入到`/dev/null`中。

可以理解为，如果写在中间，那会把隔断标准输出指定输出的文件

你可以用：

- ls 2&gt;1测试一下，不会报没有2文件的错误，但会输出一个空的文件1；
- ls xxx 2&gt;1测试，没有xxx这个文件的错误输出到了1中；
- ls xxx 2&gt;&amp;1测试，不会生成1这个文件了，不过错误跑到标准输出了；
- ls xxx &gt;out.txt 2&gt;&amp;1，实际上可换成 ls xxx 1&gt;out.txt 2&gt;&amp;1；重定向符号&gt;默认是1，错误和输出都传到out.txt了。

------

**举个栗子**

来个shell

```
//test.sh
#!/bin/sh
t
date1234
```

`chmod +x test.sh`为test.sh增加执行权限。这里我们弄了两条命令，其中t指令并不存在，执行会报错，会输出到stderr。date能正常执行，执行会输出当前时间，会输出到stdout。

执行`./test.sh &gt; res1.log`结果为：

我们发现stderr并没有被重定向到res1.log中，stderr被打印到了屏幕上。这也进一步证明了上面说的`./test.sh &gt; res1.log`等价于`./test.sh 1&gt;res1.log`

执行`./test.sh&gt;res2.log 2&gt;&amp;1`结果为：

这次我们发现stdout和stderr都被重定向到了res2.log中了。上面我们未对stderr也就是2说明如何输出，stderr就输出到了屏 幕上，这里我们不仅对stdout进行说明，重定向到res2.log中，对标准错误也进行了说明，让其重定向到res2.log的引用即 res2.log的文件描述符中。

------

**再思考一下**

为何`2&gt;&amp;1`要写在 command&gt;1 的后面，直接用2可以么。比如`ls 2&gt;a`。其实这种用法也是可以的，ls 命令列出当前的目录，用stdout（1）表示，由于这个时候没有stderr（2），这个时候执行`ls 2&gt;a`也会正常产生一个 a 的文件，但是 a 的文件中是空的，因为这时候执行ls并没有产生stderr（2）。