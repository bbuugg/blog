---
title: MaxPHP中间件迭代历史
date: 2021-12-18 22:37:35
tags:
---

以下内容为胡诌

> 对于HTTP中间件，我们只关注执行的顺序，而不关心输出内容的顺序。对于内核响应的内容，总是在所有中间件执行完成后才算完整的响应，而这个响应的输出是在所有中间件结束之后执行的，所以如果在中间件中echo的内容总是在response --> send 之前输出到浏览器的，之前就是理解上出了问题，为了让response --> send的内容也出现在中间件前后置输出内容之间而犯错写下了第一版的中间件，使用起来有一些问题，之后就按照规范来了。

补充一下，双通道的中间件实现和上面描述不一致

## 使用Pipeline模式

这和laravel, thinkphp如出一辙
```
public function handle($request, $next) {
	return $next($request);
}
```
但是这种方案不是Psr规范推荐的HTTP中间件的方案，对于其他需要这样处理的事情可以这么用，于是就有了基于Psr15规范的中间件

## 基于Psr规范的Middleware

```
public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface 
{
	return $handler->handle($request);
}
```

这个起初是直接套用管道模式的设计，将管道模式中的闭包调用更改为方法调用

```
public function then($requestHandler) 
{
	$pipeline = array_reduce($this->pipes, $this->carry(), $requestHandler);

	return $pipeline->handle($this->passable);
}

protected function carry() 
{
	return function($pipe, $stack) {
		return new class($pipe, $stack) implements RequestHandlerInterface {
			protected $stack;
			protected $pipe;
			public function __construct($pipe, $stack) {
				$this->pipe = $pipe;
				$this->stack = $stack;
			}

			public function handle(ServerRequestInterface $request) {
				return (new $this->pipe)->process($request, $this->stack);
			}
		}
	}
}

```

上面的代码可能有些问题，大概思路是这样的。这样我觉得不是很好，之前的实现和这个框架的有些像https://github.com/slimphp/Slim/blob/4.x/Slim/MiddlewareDispatcher.php

## 基于队列

这也是现在实现的版本

```
protected $middlewares;
protected $requestHandler;

public function handle (ServerRequestInterface $request): ResponseInterface
{
	if(false === $middleware = current($this->middlewares)) {
		return $this->requestHandler->handle($request);
	}
	next($this->middlewares);
	return $middleware->process($request, $this);
}

```
源码地址：https://github.com/marxphp/http-server/blob/master/src/RequestHandler.php

目前看来这样实现是比较好的，不需要创建很多闭包或者其他对象。

可以参考https://www.php-fig.org/psr/psr-15/meta/

> 以上如有不足还请指正

