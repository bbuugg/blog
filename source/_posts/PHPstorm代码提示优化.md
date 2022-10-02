---
title: PHPstorm代码提示优化
date: 2022-07-10 19:34:27
tags:
---

先看一段代码

```php
<?php

$request = Max\Di\Context::getContainer()->get(ServerRequestInterface::class);
$get     = $request->get();
```

此时会发现`get`方法是不能点击进去的，因为ide不知道$request是个什么。

解决这个问题有三种方法：

<!-- more -->

方法一：

```php
<?php
/** @var ServerRequestInterface $request */
$request = Max\Di\Context::getContainer()->get(ServerRequestInterface::class);
$get     = $request->get();
```

给$request添加一个注释，说明类型是一个ServerRequestInterface，这时候ide就会有自动提示了

方法二：

在项目目录添加`.phpstorm.meta.php` 文件，内容如下：
```php
<?php

namespace PHPSTORM_META {
    override(\Max\Di\Container::make(0), map('@'));
}
```

这时候，make方法的返回值类型就是make方法的第一个参数，这时候ide也会自动提示

方法三：

```php
	/**
     * @template T
     *
     * @param class-string<T> $id
     *
     * @return T
     */
    public function make(string $id)
    {
    }

```

使用phpstorm泛型注解，可以参考文章 https://www.evget.com/article/2021/7/19/42418.html

另外再提一点关于方法注释的问题

php 越来越向强类型转换了，因此在使用高版本php的代码中，有一些注释我认为是可以去掉的，如下：

```php
if (function_exists('base_path') === false) {
    /**
     * @param string $path
     * @return string
     */
    function base_path(string $path = ''): string
    {
        return BASE_PATH . ltrim($path, '/');
    }
}
```

其中的
```php
    /**
     * @param string $path
     * @return string
     */
```

是完全可以删除的，因为函数的原型已经描述得很清楚了，参数path类型是string，返回值是string。对于方法中没有提示类型的可以加上参数类型的注释，对于抛出异常应该加注释，如果想要解释这个函数的作用

```php
/**
* balabala
*/
function base_path(string $path = ''): string
{
	return BASE_PATH . ltrim($path, '/');
}
```

就可以了。