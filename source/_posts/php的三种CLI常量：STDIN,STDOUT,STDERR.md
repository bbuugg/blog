---
title: php的三种CLI常量：STDIN,STDOUT,STDERR
date: 2020-08-13 13:22:10
tags:
---

&gt;PHP CLI(command line interface)中，有三个系统常量，分别是STDIN、STDOUT、STDERR，代表文件句柄。
  
  
#  应用一：
![](https://images0.cnblogs.com/blog/404636/201302/27144220-4ae4ee4bdc7b45868576ee4389b62077.jpg)
```php
&lt;?php
while($line = fopen('php://stdin','r')){
    echo fgets($line);
}
?&gt;
```


应用二：
![](https://images0.cnblogs.com/blog/404636/201302/27145101-d44ee469f6f949dc97fd15e6cb88a860.jpg)
&lt;?php
    echo STDIN;
?&gt;
在dos命令行下直接返回STDIN文件指针(文件句柄)。如图：



应用三：
![](https://images0.cnblogs.com/blog/404636/201302/27145239-89e8294a9ca741fd8bb6800602d36ad2.jpg)
&lt;?php
    echo fgets(STDIN);
?&gt;
STDIN可以拿到在dos下输入的内容，fgets读取这个STDIN文件句柄，即可打印出刚才输入的内容。如图：
https://www.cnblogs.com/thinksasa/archive/2013/02/27/2935158.html