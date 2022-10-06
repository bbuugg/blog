---
title: php的三种CLI常量：STDIN,STDOUT,STDERR
date: 2020-08-13 13:22:10
tags:
---

>PHP CLI(command line interface)中，有三个系统常量，分别是STDIN、STDOUT、STDERR，代表文件句柄。
  
  
#  应用一：
```php
<?php
while($line = fopen('php://stdin','r')){
    echo fgets($line);
}
?>
```

应用二：
```php
<?php
    echo STDIN;
?>
```
在dos命令行下直接返回STDIN文件指针(文件句柄)

应用三：
```php
<?php
    echo fgets(STDIN);
?>
```
STDIN可以拿到在dos下输入的内容，fgets读取这个STDIN文件句柄，即可打印出刚才输入的内容