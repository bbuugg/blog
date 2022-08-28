---
title: PHP实现Basic认证
date: 2021-11-27 18:20:02
tags:
---

## 如何认证

对于需要basic认证的页面，我们可以让服务端响应一个
```
WWW-Authenticate: Basic
```
的header头，并且返回响应码401，浏览器会自动弹出认证的窗口。

## 客户端要做什么

> 当你输入用户名和密码后，后面的请求都会添加下面这样的头部

```
Authorization: Basic dXNlcjpwYXNz
```

其中basic后面的是base64编码的字符串，解码之后的内容是

```
user:pass
```

上面这样以用户名:密码组成的字符串

## 服务端怎么实现

看下面伪代码

```php
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        if(有Authorization头部) {
            解析头部
            if (匹配到用户) {
                继续响应
            }else {
                响应WWW-Authenticate: Basic和401
            }
        }
        
        响应WWW-Authenticate: Basic和401*/
    }
```

> 如果你使用的是Apache,那么需要在配置文件中加入

```
SetEnvIf Authorization .+ HTTP_AUTHORIZATION=$0
```

还可以查看官方提供的方案：https://www.php.net/manual/zh/features.http-auth.php