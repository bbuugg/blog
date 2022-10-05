---
title: PHP中的Session
date: 2021-04-03 21:58:51
tags:
---

# 一、session预定义常量

个人感觉PHP 最大的特点就是功能的实现都靠提供的函数扩展，函数扩展都是根据功能分大类的，session只是其中的一个扩展。
该扩展中定义了一些常量，可在PHP 编译或运行时动态载入时可用：

<!-- more -->

## **1、SID(string)**

包含着会话名及会话ID 的常量，格式为&quot;name=ID&quot;，如果会话ID 已经在恰当的会话cookie 中设定时则为空字符串。和session_id() 返回的是同一个ID。

## **2、PHP_SESSION_DISABLED(int)**

自PHP 5.4.0起可用。如果会话已禁用，则返回session_status（）的值。

## **3、PHP_SESSION_NONE(int)**

自PHP 5.4.0起可用。在会话已启用，但还没有会话时返回session_status（）的值。

## **4、PHP_SESSION_ACTIVE(int)**

自PHP 5.4.0起可用。在会话已启用，并存在会话时返回session_status（）的值。

注：会话在PHP中默认为激活（启用）。

session常量动态定义的，网友：

```ruby
var_dump(defined('SID'));  // bool(false) - Not defined...
session_start();
var_dump(defined('SID'));  // bool(true) - Defined now!
```

**自己测试了下，结果两个都是bool(true)，应该是自己的问题。之后随后重新建一个php文档，执行：**

```php
<?php
echo SID;          //提示使用了未定义常量
session_start();
echo SID;          //显示&quot;name=UID&quot;样式字符串。说明确实是动态定义，因为没有会话就没有会话的UID.
?>
```

# **二、基本用法**

通过为每个独立用户分配唯一的会话 ID，可以实现针对不同用户分别存储数据的功能。 会话通常被用来在多个页面请求之间保存及共享信息。  一般来说，会话 ID 通过 cookie 的方式发送到浏览器，并且在服务器端也是通过会话 ID 来取回会话中的数据。 如果请求中不包含会话 ID 信息，那么 PHP 就会创建一个新的会话，并为新创建的会话分配新的 ID。

会话的工作流程很简单。当开始一个会话时，PHP 会尝试从请求中查找会话 ID （通常通过会话 cookie）， 如果请求中不包含会话 ID 信息，PHP 就会创建一个新的会话。 会话开始之后，PHP 就会将会话中的数据设置到 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php) 变量中。 当 PHP 停止的时候，它会自动读取 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php) 中的内容，并将其进行序列化， 然后发送给会话保存管理器器来进行保存。

默认情况下，PHP 使用内置的文件会话保存管理器（`files`）来完成会话的保存。 也可以通过配置项[session.save_handler](http://php.net/manual/zh/session.configuration.php#ini.session.save-handler) 来修改所要采用的会话保存管理器。 对于文件会话保存管理器，会将会话数据保存到配置项[session.save_path](http://php.net/manual/zh/session.configuration.php#ini.session.save-path) 所指定的位置。

可以通过调用函数 [session_start()](http://php.net/manual/zh/function.session-start.php) 来手动开始一个会话。 如果配置项 [session.auto_start](http://php.net/manual/zh/session.configuration.php#ini.session.auto-start) 设置为`1`， 那么请求开始的时候，会话会自动开始。

PHP 脚本执行完毕之后，会话会自动关闭。 同时，也可以通过调用函数 [session_write_close()](http://php.net/manual/zh/function.session-write-close.php) 来手动关闭会话。

Example #1 在 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php) 中注册变量。

```php
<?php 
    session_start(); 
    if (!isset($_SESSION['count'])) {  
        $_SESSION['count'] = 0; 
    } else {  
        $_SESSION['count']++; 
    }
?>
```

Example #2 从 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php) 中反注册变量。

```php
<?php 
session_start(); 
unset($_SESSION['count']);
?>
```

**Caution**

千万不要使用 unset($_SESSION) 来复位超级变量 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php)， 因为这样会导致无法继续在 [$_SESSION](http://php.net/manual/zh/reserved.variables.session.php)中注册会话变量。

**Warning**

由于无法将一个引用恢复到另外一个变量， 所以不可以将引用保存到会话变量中。

**Warning**

如果会话中存在和全局变量同名的变量，那么 register_globals 会导致全局变量被会话变量覆盖。 更多信息请参考 [注册全局变量](http://php.net/manual/zh/security.globals.php)。

> Note:
>
> 无论是通过调用函数 [session_start()](http://php.net/manual/zh/function.session-start.php) 手动开启会话， 还是使用配置项 [session.auto_start](http://php.net/manual/zh/session.configuration.php#ini.session.auto-start) 自动开启会话， 对于基于文件的会话数据保存（PHP 的默认行为）而言， 在会话开始的时候都会给会话数据文件加锁， 直到 PHP 脚本执行完毕或者显式调用 [session_write_close()](http://php.net/manual/zh/function.session-write-close.php) 来保存会话数据。 在此期间，其他脚本不可以访问同一个会话数据文件。
>
> 对于大量使用 Ajax 或者并发请求的网站而言，这可能是一个严重的问题。 解决这个问题最简单的做法是如果修改了会话中的变量， 那么应该尽快调用 [session_write_close()](http://php.net/manual/zh/function.session-write-close.php) 来保存会话数据并释放文件锁。 还有一种选择就是使用支持并发操作的会话保存管理器来替代文件会话保存管理器。

理解：由于HTTP 的不可维持性（执行一段php脚本，实际上进行了一次http  通信），每段php脚本执行完时，会话会自动自动关闭。即同一时刻，只有一个php脚本访问到该session及其数据文件。为了保证每个php脚本访问到的session及其数据文件都是最新的，每次对该session的数据修改都应该及时保存进数据文件中，这在大量Ajax  应用中非常重要。



**总结session：**

1、session_destroy()：常用方法。

2、unset($_SESSION)：终结必杀，使用后无法继续使用$_SESSION 注册会话变量，所以一般不能用，算不上真正的方法。

网上的另一种方法，思路和删除cookie一样，没有具体实践，不知可行否：

 3、setcookie(session_name(),session_id(),time() -8000000,..);