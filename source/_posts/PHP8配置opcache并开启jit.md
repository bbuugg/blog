---
title: PHP8配置opcache并开启jit
date: 2022-06-15 00:00:10
cover: https://tse2-mm.cn.bing.net/th/id/OIP-C.0WhxJnoBjmg3p3YiPOuN-gHaD4?pid=ImgDet&rs=1
tags:
---

# 配置

php编译参数需要加上--enable-opcache 

<!-- more -->

配置文件如下：

```
zend_extension=opcache.so
[opcache]
opcache.enable=1

opcache.enable_cli=1

opcache.memory_consumption=528

opcache.interned_strings_buffer=8

opcache.max_accelerated_files=10000

opcache.revalidate_freq=1

opcache.fast_shutdown=1

opcache.jit_buffer_size  # 开启jit，设置buffer_size

```

请注意，如果您通过命令行运行PHP，则还可以通过-d标志传递这些选项，而不是将它们添加到php.ini：

php -dopcache.enable=1 -dopcache.jit_buffer_size=100M
如果不包含此伪指令，那么默认值将设置为0，并且JIT将不会运行。如果要在CLI脚本中测试JIT，则需要使用opcache.enable_cli来启用opcache：

php -dopcache.enable_cli=1 -dopcache.jit_buffer_size=100M
opcache.enable和opcache.enable_cli之间的区别是，如果要运行，例如内置的PHP服务器则应该使用前者。如果您实际上正在运行CLI脚本，则需要opcache.enable_cli。

在继续之前，让我们确保JIT确实有效，创建一个可通过浏览器或CLI访问的PHP脚本（取决于您测试JIT的位置），并查看以下输出opcache_get_status()：

var_dump(opcache_get_status()['jit']);

# 清除opcache

```
opcache_reset ()
opcache_invalidate () 
```