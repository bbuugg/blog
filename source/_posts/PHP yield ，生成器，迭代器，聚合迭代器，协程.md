---
title: PHP yield ，生成器，迭代器，聚合迭代器，协程
date: 2021-12-26 18:41:13
cover: /images/20221002/6605d992c6717e8ce8b191333fde8c58.jpg
tags:
---

# yield

## 语法

```php
$data = (yield $express);
```
> yield 的左边是一个赋值语句，右边可以是值（也可是表达式） 。而yield 会先执行右边的表达式，并把值$value送到生成器外面。当生成器收到值后，会执行yield左边的语句，赋值给$data.

<!-- more -->

## 使用

```php
<?php

$generator = (function () {
    $a = yield 'first';
    echo PHP_EOL;var_dump($a);
    $b = yield 'second';
    echo PHP_EOL;var_dump($b);
    $c = yield;
    echo PHP_EOL;var_dump($c);
})();

echo $generator->current();
$generator->next();
echo $generator->current();
$generator->next();
$generator->send('third');
```
php7之前需要(yield 123)

- 执行$generator->current(); 会执行第一个yield, 然后暂停
- 当执行$generator->next()或者$generator->send(null); 会往下执行直到第二个yield
- 当执行$generator->send('third'); 时候，yield实际是send的值, 将yield的值赋值给$a，所以代码中的$c为third，并且会执行下面的语句, 执行下一个yield，此时再调用$generator->current() 就是下一个yield
- 当生成器全部迭代完毕可以调用$generator->getReturn() 获取返回值
- 调用$generator->next()会到达下一个yield
- 第一次直接send() 会导致yield弹出值丢失
- yield from 左边不能有接收，因为没有意义，但是可以嵌套
- $c[] = yield 'name' => 'zhangsan' 支持这样的写法
- 当$gen迭代器被创建的时候一个rewind()方法已经被隐式调用，rewind执行会导致第一个yield被执行且忽略返回值

```php
$g = function () {
   yield 1;
   yield 2;
};

$g = $g();

var_dump($g->send('test')); // 2
```

> yield from 是一个强大且不可缺少的语法，如果只有 yield 那么就只是有了生成器，有了 yield from 那就有了一根强大的“针”——穿过一个个 生成器，按照call stack 把一个个生成器串了起来。 调用方法用 call_user_func()，调用 生成器用 yield from .

yield from: https://segmentfault.com/a/1190000022754223

# 协程
```php
<?php

$logger = (function () {
    $fd = fopen('./log.log', 'a+');
    while (true) {
        fwrite($fd, yield);
    }
    fclose($fd);
})();

$logger->send('test'. PHP_EOL);
```

ZH-CN : https://www.laruence.com/2015/05/28/3038.html
EN-US： https://www.npopov.com/2012/12/22/Cooperative-multitasking-using-coroutines-in-PHP.html