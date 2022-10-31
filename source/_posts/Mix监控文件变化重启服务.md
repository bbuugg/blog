---
title: MaxPHP监控文件变化重启服务
toc: true
date: 2022-10-10 19:05:34
tags:
---

## 安装

```shell
composer require max/watcher
```

<!-- more -->

## 使用

### 在bin/swoole.php中将进程id写入文件

```php
# 在server启动前任意位置
file_put_contents(__DIR__ . '/../runtime/master.pid', getmypid());
```

### 添加bin/watch.php文件

```php
<?php

require_once './vendor/autoload.php';

$progress = function () {
    proc_open('php bin/swoole.php', [], $pipes);
};

$progress();

$driver = new \Max\Watcher\Driver\FindDriver([__DIR__ . '/../src'], function () use ($progress) {
    posix_kill(file_get_contents(__DIR__ . '/../runtime/server.pid'), 15);

    $progress();
});

(new \Max\Watcher\Watcher($driver))->run();
```

### 执行bin/watch.php

测试修改src下的文件会自动重启，还支持inotify驱动。

## 感兴趣的可以参与开发