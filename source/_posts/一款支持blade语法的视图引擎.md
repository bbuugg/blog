---
title: 一款支持blade语法的视图引擎
date: 2021-11-21 12:06:18
tags:
---

# 前言

这是一款独立的组件，支持Blade语法的模板引擎。

>以下以Tp作为演示

ThinkPHP提供了一套视图引擎， 这里我又扩展了一套，可以使用Blade语法的引擎，而且也是可扩展的，例如你还可以使用Smarty, Twig等你熟悉的引擎，而这些只需要简单配置即可。

# 使用

**环境要求**

- php >= 7.4

> 实际上可以在任何地方使用， 测试可用的框架有ThinkPHP6.0, MaxPHP

## 安装

执行下面的命令安装max/view开发版本

```php
composer rquire max/view
```

找到以下文件
```
\vendor\max\view\publish\view.php
```

将其复制到`config/views.php`中，注意这个不是`view.php`（TP内置）

修改其中的内容

```
'engine' => \Max\View\Engines\Blade::class,
'options' => [
	// 模板目录
	'path' => __DIR__ . '/../view',
	// 编译和缓存目录
	'compile_dir' => __DIR__ . '/../runtime/views/compiled',
	// 模板调试
	'debug' => false,
	// 模板缓存
	'cache' => false,
	// 模板后缀
	'suffix' => '.blade.php',
],
```

找到下面的文件

```
App\Service.php
```

在register方法中添加如下代码

```
public function register()
{
	$engine = config('views.engine');
	$engine = new $engine(config('views.options'));
	$this->app->offsetSet(Renderer::class, new Renderer($engine));
}
```

## 使用

安装完成后你就可以使用依赖注入的方式渲染模板了

```
public function index(Renderer $renderer)
{
	return $renderer->render('index');
}
```

你也可以封装一个辅助函数，注意使用Renderer实例是要从容器中取得。

> Blade语法可以参考Laravel文档

目前支持的Blade语法有

- `{{` `}}`
- `{{--` `--}}`
- {!!  !!}
- @extends
- @yield
- @php
- @include
- @if
- @unless
- @empty
- @isset
- @foreach
- @for
- @switch
- @section

# 欢迎参与开发
**Github:** http://github.com/topyao/max-view