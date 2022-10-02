---
title: php中ob函数的用法
date: 2020-12-15 14:32:31
tags:
---

与输出缓冲区有关的配置
　　在PHP.INI中,有两个跟缓冲区紧密相关的配置项
　　1.output_buffering
　　　　该配置直接影响的是php本身的缓冲区,有3种配置参数.on/off/xK(x为某个整型数值);
　　　　on - 开启缓冲区
　　　　off - 关闭缓冲区
　　　　256k - 开启缓冲区,而且当缓冲区的内容超过256k的时候,自动刷新缓冲区(把数据发送到apache);

　　2.implicit_flush
　　　　该配置直接影响apache的缓冲区,有2种配置参数. on/off
　　　　on - 自动刷新apache缓冲区,也就是,当php发送数据到apache的缓冲区的时候,不需要等待其他指令,直接就把输出返回到浏览器
　　　　off - 不自动刷新apache缓冲区,接受到数据后,等待刷新指令

而默认直接是开启缓冲区的，所以我们可以直接不用ob_start()，所以我先把缓冲区关闭

<!-- more -->

下面几个函数的用法

- ob_start() - 打开缓冲区
- ob_get_contents() - 返回输出缓冲区的内容
- ob_flush() - 冲刷出（送出）输出缓冲区中的内容
- ob_clean() - 清空（擦掉）输出缓冲区
- ob_end_flush() - 冲刷出（送出）输出缓冲区内容并关闭缓冲
- ob_end_clean() - 清空（擦除）缓冲区并关闭输出缓冲
- flush() - 刷新输出缓冲　

> ob_start()在服务器打开一个缓冲区来保存所有的输出。所以在任何时候使用echo ，输出都将被加入缓冲区中，直到程序运行结束或者使用ob_flush()来结束。然后在服务器中缓冲区的内容才会发送到浏览器，由浏览器来解析显示。

```
ob_start();

echo "Hello ";

$out1 = ob_get_contents();

echo "World";

$out2 = ob_get_contents();123456789
```

> 输出：

```
Hello World1
```

如果只是想要存储缓存区而不是输出的话加上ob_end_clean();

```
ob_start();

echo "Hello ";

$out1 = ob_get_contents();

echo "World";

$out2 = ob_get_contents();

ob_end_clean();1234567891011
```

可以看到浏览器上没有任何输出，这时我们加上var_dump来看看out1、out2两个变量

```
ob_start();

echo "Hello ";

$out1 = ob_get_contents();

echo "World";

$out2 = ob_get_contents();



ob_end_clean();
var_dump($out1, $out2);1234567891011121314
```

> 输出：

```
string(6) "Hello " string(11) "Hello World"1
```

> 接下来讲ob_clean()跟ob_end_clean()的区别

> 使用 ob_end_clean()

```
ob_start();

echo "Hello ";

$out1 = ob_get_contents();

echo "World1";

$out2 = ob_get_contents();

ob_end_clean();

echo "World2<br>";
echo "World3<br>";

$out3 = ob_get_contents();

var_dump($out3);123456789101112131415161718
```

> 输出：

```
World2
World3
bool(false)123
```

> 使用 ob_clean()

```
ob_start();

echo "Hello ";

$out1 = ob_get_contents();

echo "World1";

$out2 = ob_get_contents();

ob_clean();

echo "World2<br>";
echo "World3<br>";

$out3 = ob_get_contents();

var_dump($out3);123456789101112131415161718
```

> 输出：

```
World2
World3
string(20) "World2
World3
"12345

```

> 这里我们对out3使用转义函数

```
var_dump(htmlentities($out3));1

```

> 输出：

```
World
World
string(32) "World<br/>World<br/>"123

```

> 解释

ob_end_clean() 跟ob_clean() 都是清空了缓冲区，不让echo输出到浏览器,这是共同点，而不同点是ob_end_clean()还关闭了缓冲区

> 接下来讲ob_end_flush()跟ob_flush()跟flush()的区别

> 使用ob_end_flush()

```
ob_start();

echo "Hello<br/>";

$out1 = ob_get_contents();

echo "World1<br/>";

$out2 = ob_get_contents();


ob_end_flush();

echo "World2<br/>";
echo "World3<br/>";

$out3 = ob_get_contents();


var_dump(htmlentities($out3));1234567891011121314151617181920

```

> 输出

```
Hello
World1
World2
World3
string(0) ""12345

```

补充：这里为了显示容易观察，我全部都给了` `

> 使用ob_flush()

```
ob_start();

echo "Hello<br/>";

$out1 = ob_get_contents();

echo "World1<br/>";

$out2 = ob_get_contents();


ob__flush();

echo "World2<br/>";
echo "World3br/>";

$out3 = ob_get_contents();


var_dump(htmlentities($out3));1234567891011121314151617181920

```

> 输出

```
Hello
World1
World2
World3
string(32) "World2<br/>World3<br/>"12345

```

> 使用flush()

```
ob_start();

echo "Hello<br/>";

$out1 = ob_get_contents();

echo "World1<br/>";

$out2 = ob_get_contents();


flush();

echo "World2<br/>";
echo "World3br/>";

$out3 = ob_get_contents();


var_dump(htmlentities($out3));1234567891011121314151617181920
```

> 输出

```
Hello
World1
World2
World3
string(67) "Hello<br/>World1<br/>World2<br/>World3<br/>"12345
```

> 区别

可以看出ob_end_flush() 是输出了缓冲区的内容并且关闭了缓冲区,而ob_flush()只是刷出了缓冲区内容，相当于将缓冲区清空，而flush()输出了缓冲区内容也没有将缓冲区清空，所以下面的缓冲区内容还会继续追加。

> 总结

只能在实践中继续成长，有什么不对的地方望大家指出。

https://blog.csdn.net/qq_33862778/article/details/80787510

header("Location:login.php")应该注意的几个问题
header("Location:login.php")应该注意的几个问题

header("Location:")作为php的转向语句。其实在使用中，他有几点需要注意的地方。

1、要求header前没有任何输出

但是很多时候在header前我们已经输出了好多东西了，此时如果再次header的话，显然是出错的，在这里我们启用了一个ob的概念，ob的意思是在服务器端先存储有关输出，等待适当的时机再输出，而不是像现在这样运行一句，输出一句,发现header语句就只能报错了。

具体的语句有： ob_start(); ob_end_clean();ob_flush();.........

2、在header("Location:")后要及时exit

否则他是会继续执行的，虽然在浏览器端你看不到相应的数据出现，但是如果你进行抓包分析的话，你就会看到下面的语句也是在执行的。而且被输送到了浏览器客户端，只不过是没有被浏览器执行为html而已（浏览器执行了header进行了转向操作）。

所以,标准的使用方法是：

ob_start();

........

if ( something ){

ob_end_clean();

header("Location: yourlocation")；

exit;

else{

..........

ob_flush(); //可省略

要想在header前有输出的话，可以修改php.ini文件

output_handler =mb_output_handler

或 output_handler =on

Output Control 函数可以让你自由控制脚本中数据的输出。它非常地有用，特别是对于：当你想在数据已经输出后，再输出文件头的情况。输出控制函数不对使用 header() 或 setcookie(), 发送的文件头信息产生影响,只对那些类似于 echo() 和 PHP 代码的数据块有作用。
一、 相关函数简介：
1、Flush：刷新缓冲区的内容，输出。
函数格式：flush()
说明：这个函数经常使用，效率很高。
2、ob_start ：打开输出缓冲区
函数格式：void ob_start(void)
说明：当缓冲区激活时，所有来自PHP程序的非文件头信息均不会发送，而是保存在内部缓冲区。为了输出缓冲区的内容，可以使用ob_end_flush()或flush()输出缓冲区的内容。
3 、ob_get_contents ：返回内部缓冲区的内容。
使用方法：string ob_get_contents(void)
说明：这个函数会返回当前缓冲区中的内容，如果输出缓冲区没有激活，则返回 FALSE 。
4、ob_get_length：返回内部缓冲区的长度。
使用方法：int ob_get_length(void)
说明：这个函数会返回当前缓冲区中的长度；和ob_get_contents一样，如果输出缓冲区没有激活。则返回 FALSE。
5、ob_end_flush ：发送内部缓冲区的内容到浏览器，并且关闭输出缓冲区。
使用方法：void ob_end_flush(void)
说明：这个函数发送输出缓冲区的内容（如果有的话）。
6、ob_end_clean：删除内部缓冲区的内容，并且关闭内部缓冲区
使用方法：void ob_end_clean(void)
说明：这个函数不会输出内部缓冲区的内容而是把它删除！
7、ob_implicit_flush：打开或关闭绝对刷新
使用方法：void ob_implicit_flush ([int flag])
说明：使用过Perl的人都知道|=x的意义，这个字符串可以打开/关闭缓冲区，而obimplicitflush函数也和那个一样，默认为关闭缓冲区，打开绝对输出后，每个脚本输出都直接发送到浏览器，不再需要调用flush()obstart()开始输出缓冲,这时PHP停止输出,在这以后的输出都被转到一个内部的缓冲里.obgetcontents()这个函数返回内部缓冲的内容.这就等于把这些输出都变成了字符串.obgetlength()返回内部缓冲的长度.obendflush()结束输出缓冲,并输出缓冲里的内容.在这以后的输出都是正常输出.obendclean()结束输出缓冲,并扔掉缓冲里的内容.举个例子,vardump()函数输出一个变量的结构和内容,这在调试的时候很有用.但如果变量的内容里有<,>等HTML的特殊字符,输出到网页里就看不见了.怎么办呢?用输出缓冲函数能很容易的解决这个问题.obstart();vardump(var);
out=obgetcontents();obendclean();这时vardump()的输出已经存在out 里了. 你可以现在就输出:
echo '<pre>' . htmlspecialchars($out) . '</pre>' ;
或者等到将来, 再或者把这个字符串送到模板(Template)里再输出.
https://www.cnblogs.com/suizhikuo/archive/2012/11/26/2789101.html