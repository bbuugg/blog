---
title: ob系列函数总结
date: 2020-11-18 09:32:37
tags:
---

ob系列函数中常用函数

ob_start();            //打开一个输出缓冲区，所有的输出信息不再直接发送到浏览器，而是保存在输出缓冲区里面。
ob_clean();            //删除内部缓冲区的内容，不关闭缓冲区(不输出)。
ob_end_clean();        //删除内部缓冲区的内容，关闭缓冲区(不输出)。
ob_get_clean();        //返回内部缓冲区的内容，关闭缓冲区。相当于执行 ob_get_contents() and ob_end_clean()
ob_flush();            //发送内部缓冲区的内容到浏览器，删除缓冲区的内容，不关闭缓冲区。
ob_end_flush();        //发送内部缓冲区的内容到浏览器，删除缓冲区的内容，关闭缓冲区。
ob_get_flush();        //返回内部缓冲区的内容，并关闭缓冲区，再释放缓冲区的内容。相当于ob_end_flush()并返回缓冲区内容。
flush();               //将ob_flush释放出来的内容，以及不在PHP缓冲区中的内容，全部输出至浏览器；刷新内部缓冲区的内容，并输出。

ob_get_contents();     //返回缓冲区的内容，不输出。
ob_get_length();       //返回内部缓冲区的长度，如果缓冲区未被激活，该函数返回FALSE。
ob_get_level();        //Return the nesting level of the output buffering mechanism.
ob_get_status();       //Get status of output buffers.

ob_implicit_flush();   //打开或关闭绝对刷新，默认为关闭，打开后ob_implicit_flush(true)，所谓绝对刷新，即当有输出语句(e.g: echo)被执行时，便把输出直接发送到浏览器，而不再需要调用flush()或等到脚本结束时才输出。

ob_gzhandler               //ob_start回调函数，用gzip压缩缓冲区的内容。
ob_list_handlers           //List all output handlers in use
output_add_rewrite_var     //Add URL rewriter values
output_reset_rewrite_vars  //Reset URL rewriter values

这些函数的行为受php_ini设置的影响：
output_buffering       //该值为ON时，将在所有脚本中使用输出控制；若该值为一个数字，则代表缓冲区的最大字节限制，当缓存内容达到该上限时将会自动向浏览器输出当前的缓冲区里的内容。
output_handler         //该选项可将脚本所有的输出，重定向到一个函数。例如，将 output_handler 设置为 mb_output_handler() 时，字符的编码将被修改为指定的编码。设置的任何处理函数，将自动的处理输出缓冲。
implicit_flush         //作用同ob_implicit_flush，默认为Off。

用PHP的ob_start();
控制您的浏览器cache


Output Control 函数可以让你自由控制脚本中数据的输出。它非常地有用，特别是对于：当你想在数据已经输出后，再输出文件头的情况。输出控制函数不对使用 header() 或 setcookie(), 发送的文件头信息产生影响,只对那些类似于 echo() 和 PHP 代码的数据块有作用。
我们先举一个简单的例子，让大家对Output Control有一个大致的印象：
Example 1.

程序代码
```php
<?php
ob_start(); //打开缓冲区
echo \"Hellon\"; //输出
header("location:index.php"); //把浏览器重定向到index.php
ob_end_flush();//输出全部内容到浏览器
?>
```

所有对header()函数有了解的人都知道，这个函数会发送一段文件头给浏览器，但是如果在使用这个函数之前已经有了任何输出（包括空输出，比如空格，回车和换行）就会提示出错。如果我们去掉第一行的ob_start()，再执行此程序，我们会发现得到了一条错误提示："Header had all ready send by"！但是加上ob_start，就不会提示出错，原因是当打开了缓冲区，echo后面的字符不会输出到浏览器，而是保留在服务器，直到你使用 flush或者ob_end_flush才会输出，所以并不会有任何文件头输出的错误！


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
说明：使用过Perl的人都知道$|=x的意义，这个字符串可以打开/关闭缓冲区，而ob_implicit_flush函数也和那个一样，默认为关闭缓冲区，打开绝对输出后，每个脚本输出都直接发送到浏览器，不再需要调用 flush()


二、深入了解：

1. 关于Flush函数：
这个函数在PHP3中就出现了，是一个效率很高的函数，他有一个非常有用的功能就是刷新browser的cache.我们举一个运行效果非常明显的例子来说明flush.
Example 2.
程序代码
```php
<?php
    for($i = 1; $i <= 300; $i++ ) print(" ");
    // 这一句话非常关键，cache的结构使得它的内容只有达到一定的大小才能从浏览器里输出
    // 换言之，如果cache的内容不达到一定的大小，它是不会在程序执行完毕前输出的。经
    // 过测试，我发现这个大小的底限是256个字符长。这意味着cache以后接收的内容都会
    // 源源不断的被发送出去。
    For($j = 1; $j <= 20; $j++) {
    echo $j."
    ";
    flush(); //这一部会使cache新增的内容被挤出去，显示到浏览器上
    sleep(1); //让程序"睡"一秒钟，会让你把效果看得更清楚
}
?>
```

注：如果在程序的首部加入ob_implicit_flush()打开绝对刷新,就可以在程序中不再使用flush(),这样做的好处是：提高效率！

1. 关于ob系列函数：
我想先引用我的好朋友y10k的一个例子：
Example 3.

比如你用得到服务器和客户端的设置信息，但是这个信息会因为客户端的不同而不同，如果想要保存phpinfo()函数的输出怎么办呢？在没有缓冲区控制之前，可以说一点办法也没有，但是有了缓冲区的控制，我们可以轻松的解决：
程序代码
```php
<?php
ob_start(); //打开缓冲区
phpinfo(); //使用phpinfo函数
$info=ob_get_contents(); //得到缓冲区的内容并且赋值给$info
$file=fopen(\'info.txt\',\'w\'); //打开文件info.txt
fwrite($file,$info); //写入信息到info.txt
fclose($file); //关闭文件info.txt
?>
```
 

用以上的方法，就可以把不同用户的phpinfo信息保存下来，这在以前恐怕没有办法办到！其实上面就是将一些"过程"转化为"函数"的方法！
或许有人会问："难道就这个样子吗？还有没有其他用途？"当然有了，比如笔者论坛的PHP 语法加亮显示就和这个有关（PHP默认的语法加亮显示函数会直接输出，不能保存结果，如果在每次调用都显示恐怕会很浪费CPU，笔者的论坛就把语法加亮函数显示的结果用控制缓冲区的方法保留了），大家如果感兴趣的话可以来看看

可能现在大家对ob_start()的功能有了一定的了解，上面的一个例子看似简单，但实际上已经掌握了使用ob_start()的要点。
<1>.使用ob_start打开browser的cache，这样可以保证cache的内容在你调用flush(),ob_end_flush()（或程序执行完毕）之前不会被输出。
<2>.现在的你应该知道你所拥有的优势：可以在任何输出内容后面使用header,setcookie以及session，这是 ob_start一个很大的特点；也可以使用ob_start的参数，在cache被写入后，然后自动运行命令，比如ob_start(\ "ob_gzhandler\")；而我们最常用的做法是用ob_get_contents()得到cache中的内容，然后再进行处理……
<3>.当处理完毕后，我们可以使用各种方法输出，flush(),ob_end_flush(),以及等到程序执行完毕后的自动输出。当然，如果你用的是ob_get_contents()，那么就要你自己控制输出方式了。

来，让我们看看能用ob系列函数做些什么……

一、 静态模版技术

简介：所谓静态模版技术就是通过某种方式，使得用户在client端得到的是由PHP产生的html页面。如果这个html页面不会再被更新，那么当另外的用户再次浏览此页面时，程序将不会再调用PHP以及相关的数据库，对于某些信息量比较大的网站，例如sina,163,sohu。类似这种的技术带来的好处是非常巨大的。

我所知道的实现静态输出的有两种办法：
<1>.通过y10k修改的phplib的一个叫template.inc.php类实现。
<2>.使用ob系列函数实现。
对于第一种方法，因为不是这篇文章所要研究的问题，所以不再赘述。
我们现在来看一看第二种方法的具体实现：
Example 4.


程序代码 程序代码
```php
<?php
ob_start();//打开缓冲区
?>
php页面的全部输出
<?
$content = ob_get_contents();//取得php页面输出的全部内容
$fp = fopen("output00001.html", "w"); //创建一个文件，并打开，准备写入
fwrite($fp, $content); //把php页面的内容全部写入output00001.html，然后……
fclose($fp);
?>
```

这样，所谓的静态模版就很容易的被实现了……

二、 捕捉输出

以上的Example 4.是一种最简单的情况，你还可以在写入前对$content进行操作……
你可以设法捕捉一些关键字，然后去对它进行再处理，比如Example 3.所述的PHP语法高亮显示。个人认为，这个功能是此函数最大的精华所在，它可以解决各种各样的问题，但需要你有足够的想象力……

Example 5.

程序代码 程序代码
```php
<?php
function run_code($code) {
    If($code) {
        ob_start();
        eval($code);
       $contents = ob_get_contents();
       ob_end_clean();
    }else {
       echo "错误！没有输出";
       exit();
}
return $contents;
?>
}
```

 

以上这个例子的用途不是很大，不过很典型$code的本身就是一个含有变量的输出页面，而这个例子用eval把$code中的变量替换，然后对输出结果再进行输出捕捉，再一次的进行处理……

二、 输出缓存句柄ob_gzhandler


PHP4.0.4有一个新的输出缓存句柄ob_gzhandler，它与前面的类相似，但用法不同。使用ob_gzhandler时要在php.ini中加入的内容如下：   

output_handler = ob_gzhandler;

这行代码使得PHP激活输出缓存，并压缩它发送出去的所有内容。
如果由于某种原因你不想在php.ini中加上这行代码，你还可以通过PHP源文件所在目录的.htaccess文件改变默认的服务器行为（不压缩），语法如下：    
```php
php_value output_handler ob_gzhandler
```
或者是从PHP代码调用，如下所示：
```php
ob_start("ob_gzhandler");
```
采用输出缓存句柄的方法确实非常有效，而且不会给服务器带来什么特殊的负荷。但必须注意的是，Netscape Communicator对压缩图形的支持不佳，因此除非你能够保证所有用户都使用IE浏览器，否则你应该禁止压缩JPEG和GIF图形。一般地，对于所有其他文件，这种压缩都有效，但建议你针对各种浏览器都分别进行测试，特别是当你使用了特殊的插件或者数据查看器时这一点尤其重要。
注意事项：
1、一些Web服务器的output_buffering默认是4069字符或者更大，即输出内容必须达到4069字符服务器才会flush刷新输出缓冲，为了确保flush有效，最好在ob_flush()函数前有以下语句：
代码如下:
```php
print str_repeat("", 4096);  //以确保到达output_buffering值
```
2、ob_* 系列函数是操作PHP本身的输出缓冲区，所以ob_flush只刷新PHP自身的缓冲区，而flush是刷新apache的缓冲区。所以，正确使用俩者的顺序是：先ob_flush，然后flush。ob_flush是把数据从PHP的缓冲中释放出来，flush是把缓冲内/外的数据全部发送到浏览器。
3、不要误认为用了ob_start()后，脚本的echo/print等输出就永远不会显示在浏览器上了。因为PHP脚本运行结束后，会自动刷新缓冲区并输出内容。