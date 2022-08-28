---
title: 如何让MixPHP支持Aop和注解路由
date: 2022-05-22 21:27:31
tags:
---

# 前提条件

```
php >= 8.0
```

# 初始化

如果你是刚初始化的项目，需要修改composer.json添加以下内容

```json
"minimum-stability": "dev"
```

首先需要安装一个aop包

```shell
composer require max/aop:dev-master
```

# 准备工作

通常会使用swoole服务，因此需要修改bin/swoole.php文件

```php
$loader = require __DIR__ . '/../vendor/autoload.php';

\Max\Aop\Scanner::init($loader, new \Max\Aop\ScannerConfig([
    'cache'      => false,
    'paths'      => [
        __DIR__ . '/../src/Controller',
    ],
    'collectors' => [
         \App\Routing\RouteCollector::class,
    ],
    'runtimeDir' => __DIR__ . '/../runtime',
]));
```

如上，`init`方法第一个参数传入加载器，第二个为配置对象

- cache 是否缓存
- paths 注解扫描路径，默认是收集了属性和切面注解
- collectors 注解收集器
- runtimeDir 运行时路径

# 怎么使用

## 切面

代码如下

```php
<?php

namespace App\Controller;

use App\Aspects\Round;
use App\Container\DB;
use Max\Aop\Collectors\AspectCollector;
use Max\Di\Annotations\Inject;
use Mix\Vega\Context;

class Hello
{
    #[Inject]
    protected DB $DB;

    /**
     * @param Context $ctx
     */
    #[Round(id: 1)]
    public function index(Context $ctx)
    {
        var_dump($this->DB);
        $ctx->string(200, 'hello, world!');
    }
}
```

### 属性注入

代码如下，使用DB提示$DB类型，添加Inject注解，注意：使用Inject意味着这是个单例，会常驻

### 方法切入

切面类Round如下：

```php
<?php

namespace App\Aspects;

use Closure;
use Max\Aop\Contracts\AspectInterface;
use Max\Aop\JoinPoint;

#[\Attribute(\Attribute::TARGET_METHOD)]
class Round implements AspectInterface
{
    public function __construct(protected int $id)
    {
    }

    public function process(JoinPoint $joinPoint, Closure $next): mixed
    {
        var_dump('before');
        var_dump($this->id);
        $result = $next($joinPoint);
        var_dump('after');
        return $result;
    }
}
```

### 启动服务

```shell
php bin/swoole.php start
```

### 测试

```shell
curl http://127.0.0.1:9501/hello
```

### 控制台输出

```
string(6) "before"
int(1)
object(App\Container\DB)#851 (0) {
}
string(5) "after"
```

## 注解路由

### 路由收集器

```php
<?php

namespace App\Routing;

use ArrayObject;
use Max\Aop\Collectors\AnnotationCollector;
use Mix\Vega\Engine;

class RouteCollector extends AnnotationCollector
{
    protected static Engine      $vega;
    protected static ArrayObject $controllerCache;
    protected static bool        $initialized = false;

    public static function init(Engine $vega)
    {
        if (!self::$initialized) {
            self::$vega            = $vega;
            self::$controllerCache = new ArrayObject();
            self::$initialized     = true;
        }
    }

    public static function collectMethod(string $class, string $method, object $attribute): void
    {
        if ($attribute instanceof RequestMapping) {
            self::$vega->handle($attribute->getPath(), [self::getController($class), $method])->methods(...$attribute->getMethods());
        }
    }

    protected static function getController(string $class)
    {
        if (!self::$controllerCache->offsetExists($class)) {
            self::$controllerCache->offsetSet($class, new $class);
        }
        return self::$controllerCache->offsetGet($class);
    }
}
```

### 路由注解

```php
<?php

namespace App\Routing;

#[\Attribute(\Attribute::TARGET_METHOD)]
class RequestMapping
{
    protected array $methods = ['GET', 'HEAD', 'POST'];

    public function __construct(protected string $path, array $methods = [])
    {
        if (!empty($methods)) {
            $this->methods = $methods;
        }
    }

    /**
     * @return string
     */
    public function getPath(): string
    {
        return '/' . ltrim($this->path, '/');
    }

    /**
     * @return array|string[]
     */
    public function getMethods(): array
    {
        return $this->methods;
    }
}
```

控制器方法如下

```php
<?php

namespace App\Controller;

use App\Aspects\Round;
use App\Container\DB;
use App\Routing\RequestMapping;
use Max\Di\Annotations\Inject;
use Mix\Vega\Context;

class Hello
{
    #[Inject]
    protected DB $DB;

    /**
     * @param Context $ctx
     */
    #[Round(id: 1)]
    #[RequestMapping(path: '/', methods: ['GET', 'PUT'])]
    public function index(Context $ctx)
    {
        var_dump($this->DB);
        $ctx->string(200, 'hello, world!');
    }
}
```

上面这个RequestMapping注册的路由类似:

```php
$vega->handle('/', [new Hello(), 'index'])->methods('GET', 'PUT');
```

### 启动服务

```
php bin/swoole.php start
```

测试

```
curl http://127.0.0.1:9501/
```

返回

```
StatusCode        : 200
StatusDescription : OK
Content           : hello, world!
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Content-Length: 13
                    Content-Type: text/html
                    Date: Sun, 22 May 2022 13:45:50 GMT
                    Server: swoole-http-server

                    hello, world!
Forms             : {}
Headers           : {[Connection, keep-alive], [Content-Length, 13], [Cont 
                    ent-Type, text/html], [Date, Sun, 22 May 2022 13:45:50 
                     GMT]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 13
```

# 总结

开发中，切勿用于生产环境，否则产生的损失和作者无关，如果感兴趣可以参与开发：https://github.com/topyao/max-aop