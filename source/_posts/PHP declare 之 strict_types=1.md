---
title: PHP declare 之 strict_types=1
date: 2021-04-04 15:33:52
tags:
---

&gt;PHP中申明 declare(strict_types=1)的作用

`strict_types=1` 及开启严格模式.默认是弱类型校验.具体严格模式和普通模式的区别见下面代码.

# Example 1:

```php
&lt;?php
declare(strict_types=1);
 
function  foo():int{
    return 1.11;
}

echo foo();
code2:
```
 
# Example2
 
```php
&lt;?php
//declare(strict_types=1);

function  foo():int{
	return 1.11;
}
     
echo foo();
```

以上代码会怎样呢?

`Example1` 抛出Type Error的语法错误:

注意:declare 是会校验这个文件下所有使用的的函数,不管他是否是在declare指令文件中申明的!

`Example2` 返回值为1(这里是由于php7新特性决定的);由于声明了返回类型int，所以会浮点数会被转为整形