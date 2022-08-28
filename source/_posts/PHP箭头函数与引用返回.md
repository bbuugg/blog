---
title: PHP箭头函数与引用返回
date: 2021-11-02 22:07:42
tags:
---

# 箭头函数

文档来自PHP手册： https://www.php.net/manual/zh/functions.arrow.php

> 箭头函数是 PHP 7.4 的新语法，是一种更简洁的 匿名函数 写法。

匿名函数和箭头函数都是 `Closure` 类的实现。

箭头函数的基本语法为 
```
fn (argument_list) => expr
```

箭头函数支持与 匿名函数 相同的功能，只是其父作用域的变量总是自动的。

当表达式中使用的变量是在父作用域中定义的，它将被隐式地按值捕获。在下面的例子中，函数 `$fn1` 和 `$fn2` 的行为是一样的。
> 示例 箭头函数自动捕捉变量的值

```


<?php

$y = 1;

$fn1 = fn($x) => $x + $y;
// 相当于 using $y by value:
$fn2 = function ($x) use ($y) {
    return $x + $y;
};

var_export($fn1(3));
?>
```

> 示例 箭头函数自动捕捉变量的值，即使在嵌套的情况下

```
<?php

$z = 1;
$fn = fn($x) => fn($y) => $x * $y + $z;
// 输出 51
var_export($fn(5)(10));
?>
```

> 以下均为有效箭头函数例子

```
<?php

fn(array $x) => $x;
static fn(): int => $x;
fn($x = 42) => $x;
fn(&$x) => $x;
fn&($x) => $x;
fn($x, ...$rest) => $rest;

?>
```
箭头函数会自动绑定上下文变量，这相当于对箭头函数内部使用的每一个变量 $x 执行了一个 use($x)。这意味着不可能修改外部作用域的任何值，若要实现对值的修改，可以使用 匿名函数 来替代。

> 示例 来自外部范围的值不能在箭头函数内修改

```
<?php

$x = 1;
$fn = fn() => $x++; // 不会影响 x 的值
$fn();
var_export($x);  // 输出 1

?>
```

# 引用返回

> 字面意思就是函数返回一个引用

## 方法

```
class Test {
    public function &test () {
        $a = 1;
		return $a;
    }
}
```

## 函数

```
function &test()
{
    $a = 1;
    return $a;
}
```

## 匿名函数

```
$a = function &() {
    $b = 1;
    return $b;
};
```

## 箭头函数

```
$a = fn &($b) => $b;
```

关于引用返回的介绍可以参考官方文档：https://www.php.net/manual/zh/language.references.return.php