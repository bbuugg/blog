---
title: PHP如何实现Aop
date: 2022-05-22 18:15:45
cover: https://tse3-mm.cn.bing.net/th/id/OIP-C.45qjs07Dj_Y0I4t99BfJywHaEK?pid=ImgDet&rs=1
tags:
---

# 前言

至于什么是面向切面，面向切面的优势可以参考： https://zhuanlan.zhihu.com/p/421999882 和 https://www.cnblogs.com/q1104460935/p/10044965.html

目前看来比较好的实现方式是代理类，代理类就是对原始类文件进行修改，并且通过自动加载加载代理类而非原始类从而实现某些功能。对于常驻内存型的应用，可以使用子进程扫描的方式直接生成代理类，非常驻型则需要提前生成好后将代理类的map缓存起来下次直接使用。

下面讲下基于PHP8原生注解和上述的思路实现的切面

<!-- more -->

# 代理类

先看下这个类

```php
<?php

declare(strict_types=1);

/**
 * This file is part of the Max package.
 *
 * (c) Cheng Yao <987861463@qq.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\Http\Controllers;

use Max\Di\Annotations\Inject;
use Max\Routing\Annotations\Controller;
use Max\Routing\Annotations\GetMapping;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

#[Controller(prefix: '/')]
class IndexController
{
    #[Inject]
    protected ServerRequestInterface $request;
    #[Inject]
    protected ResponseInterface      $response;

    #[GetMapping(path: '/')]
    #[Cacheable]
    public function index(): array
    {
        return $this->response->success(message: 'Hello, ' . $this->request->get('name', 'MaxPHP') . '!');
    }
}
```

使用了类注解，属性注解，方法注解。和代理类相关的主要有属性注解和方法注解，来看下生成的代理类

```php
<?php

declare (strict_types=1);
/**
 * This file is part of the Max package.
 *
 * (c) Cheng Yao <987861463@qq.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
namespace App\Http\Controllers;

use Max\Cache\Aspects\Cacheable;
use Max\Di\Annotations\Inject;
use Max\Routing\Annotations\Controller;
use Max\Routing\Annotations\GetMapping;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
#[Controller(prefix: '/')]
class IndexController
{
    use \Max\Aop\ProxyHandler;
    use \Max\Aop\PropertyHandler;
    public function __construct()
    {
        $this->__handleProperties();
    }
    #[Inject]
    protected ServerRequestInterface $request;
    #[Inject]
    protected ResponseInterface $response;

    #[GetMapping(path: '/')]
    #[Cacheable]
    public function index() : array
    {
        return $this->__callViaProxy(__FUNCTION__, function () {
            return $this->response->success(message: 'Hello, ' . $this->request->get('name', 'MaxPHP') . '!');
        }, func_get_args());
    }
}
```

对比上面的代码，可以发现由于使用了Inject和Cacheable注解，代理类多了构造方法，并且index方法的方法体被$this->__callViaProxy包裹了。在运行时实际加载的类文件是代理类，而不是原始类。那么如何实现这一过程呢，下面是hyperf的一段代码

```php
$loaders = spl_autoload_functions();

// Proxy the composer class loader
foreach ($loaders as &$loader) {
    $unregisterLoader = $loader;
    if (is_array($loader) && $loader[0] instanceof ComposerClassLoader) {
        /** @var ComposerClassLoader $composerClassLoader */
        $composerClassLoader = $loader[0];
        AnnotationRegistry::registerLoader(function ($class) use ($composerClassLoader) {
            return (bool) $composerClassLoader->findFile($class);
        });
        $loader[0] = new static($composerClassLoader, $proxyFileDirPath, $configDir);
    }
    spl_autoload_unregister($unregisterLoader);
}

unset($loader);

// Re-register the loaders
foreach ($loaders as $loader) {
    spl_autoload_register($loader);
}
```

注册新的类加载器，而加载被代理的文件时会加载对应的代理类。下面是MaxPHP的实现

```php
/** @var Composer\Autoload\ClassLoader $loader */
unlink($proxyMap);
if (!file_exists($proxyMap)) {
    if (($pid = pcntl_fork()) == -1) {
        throw new ProcessException('Process fork failed.');
    }
    pcntl_wait($pid);
}
$loader->addClassMap($this->getProxyMap());
// 收集注解
```

思路：因为扫描注解过程会加载类文件，加载之后不能被重新加载（目前不知道咋实现，知道的可以讲下），所以采用子进程扫描生成代理类地图。如上代码，$proxyMap是代理类地图文件，内容例如下：

```php
<?php 
return array (
  'App\\Http\\Controllers\\IndexController' => '/home/cheng/max/max-http-project/bin/../runtime/aop/proxy/App_Http_Controllers_IndexController_Proxy.php',
  'App\\Listeners\\DatabaseQueryListener' => '/home/cheng/max/max-http-project/bin/../runtime/aop/proxy/App_Listeners_DatabaseQueryListener_Proxy.php',
  'App\\Http\\Middlewares\\ExceptionHandlerMiddleware' => '/home/cheng/max/max-http-project/bin/../runtime/aop/proxy/App_Http_Middlewares_ExceptionHandlerMiddleware_Proxy.php',
);
```

当文件不存在的时候fork子进程，然后使用pcntl_wait等待子进程退出，接着走到$this->getProxyMap() 方法，方法内容如下：

```php
protected function getProxyMap()
{
    if(代理类地图不存在) {
        // 收集注解
        // 生成代理类，并写入
        // 生成代理类地图，并写入
        exit;
    }
    
    // 返回代理类地图
}
```

如上伪代码，代理类不存在会导致子进程退出，而在上面的代码中事先将代理类地图删掉了，所以重启服务肯定会启动两个进程，一个扫描注解，生成代理类后退出，一个等待退出后直接加载代理类地图 ，当然框架中实现还添加了缓存，可以参考max/aop包。重新回到fork子进程的代码，可以看到$loader->addClassMap()， 代码如下：

```php
public function addClassMap(array $classMap)
{
    if ($this->classMap) {
        $this->classMap = array_merge($this->classMap, $classMap);
    } else {
        $this->classMap = $classMap;
    }
}
```

将覆盖原始的类自动加载映射，至此代理类生成原理和代理方法介绍完毕，生成代理类需要使用"nikic/php-parser"包。

# 如何代理

接下来看到代理类的代码，控制器方法里添加了以下代码

```php
public function __construct()
{
    $this->__handleProperties();
}
```

$this->__handleProperties() 主要是用来处理属性的，在注解扫描过程中会将符合条件的注解收集起来，这个方法会根据收集的注解，在实例化对象后将对应的属性使用对应的注解来处理，例如Inject注解，将容器中的实例注入到该属性中，因此在编写代码的时候不必要在构造方法中初始化值，都有代理类完成。这样的好处是你不必依赖容器或这其他服务来注入或者操作属性，直接使用new关键字实例化依然可以自动注入

# 被切入的方法

然后看到控制器方法index

```php
public function index() : array
{
    return $this->__callViaProxy(__FUNCTION__, function () {
        return $this->response->success(message: 'Hello, ' . $this->request->get('name', 'MaxPHP') . '!');
    }, func_get_args());
}
```

可以看到$this->__callVieProxy传递了三个参数，依次是本方法名，闭包（包含原方法体），原方法参数列表，走到这，就意味着这个方法被切入了。

来看下__callVieProxy方法：

```php
protected function __callViaProxy(string $method, Closure $callback, array $parameters): mixed
{
    /** @var AspectInterface $aspect */
    $pipeline = array_reduce(
        array_reverse([...AspectCollector::getClassAspects(__CLASS__), ...AspectCollector::getMethodAspects(__CLASS__, $method)]),
        fn($stack, $aspect) => fn(JoinPoint $joinPoint) => $aspect->process($joinPoint, $stack),
        fn(JoinPoint $joinPoint) => $joinPoint->process()
    );
    return $pipeline(new JoinPoint($this, $method, $parameters, $callback));
}
```

方法很简单，将收集的该方法的切面，使用array_reduce处理。最终调用的方法在JoinPoint中，该对象包含所有元数据，例如对象，方法和方法参数，这些都是可以在切面类中拿到并且可以修改的，最终调用的方法如下

```php
public function process(): mixed
{
    return call_user_func_array($this->callback, $this->parameters);
}
```

可以看到调用闭包并传递处理后的参数。

## 切面类实现如下

```php
<?php

declare(strict_types=1);

/**
 * This file is part of the Max package.
 *
 * (c) Cheng Yao <987861463@qq.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Max\Cache\Aspects;

use Closure;
use Max\Aop\Contracts\AspectInterface;
use Max\Aop\JoinPoint;
use Psr\Container\ContainerExceptionInterface;
use ReflectionException;

#[\Attribute(\Attribute::TARGET_METHOD)]
class TestRandom implements AspectInterface
{
    public function __construct(
        protected int     $ramdom = 0,
    )
    {
    }

    /**
     * @throws ContainerExceptionInterface
     * @throws ReflectionException
     */
    public function process(JoinPoint $joinPoint, Closure $next): mixed
    {
        echo 'before';
        $result = $next($joinPoint);
        echo 'after';
        return $result;
    }
}
```

可以看到调用方法和pipeline原理类似。构造方法的参数是可以通过使用注解的时候传递的。

# 总结

php的aop的重点：代理类生成，如何调用

浅薄理解，相对于其他框架的思路可能略显幼稚。感兴趣可以参与开发 max/aop： https://github.com/topyao/max-aop