---
title: 怎么在maxphp中集成Illuminate-database
date: 2022-07-10 10:11:34
tags:
---

```
composer require illuminate/database illuminate/pagination illuminate/events
```

<!-- more -->

# 配置
```php
<?php

return [
    // 默认数据库
    'default'     => 'mysql',
    // 各种数据库配置
    'connections' => [
        'mysql' => [
            'driver'      => 'mysql',
            'host'        => '127.0.0.1',
            'port'        => 3306,
            'database'    => env('DB_NAME', 'name'),
            'username'    => env('DB_USER', 'user'),
            'password'    => env('DB_PASS', 'pass'),
            'unix_socket' => '',
            'charset'     => 'utf8',
            'collation'   => 'utf8_unicode_ci',
            'prefix'      => '',
            'strict'      => true,
            'engine'      => null,
        ],
    ],
];

```

# 初始化

```
if (!class_exists(Manager::class)) {
    return;
}
$connections = config('database.connections');
if (!$connections) {
    return;
}
$capsule = new Manager();
$configs = config('database');
// 扩展mongodb，需要安装对应的包
$capsule->getDatabaseManager()->extend('mongodb', function($config, $name) {
    $config['name'] = $name;
    return new MongodbConnection($config);
});
if (isset($configs['default'])) {
    $default_config = $connections[$configs['default']];
    $capsule->addConnection($default_config);
}
foreach ($connections as $name => $config) {
    $capsule->addConnection($config, $name);
}
if (class_exists(Dispatcher::class)) {
    $capsule->setEventDispatcher(new Dispatcher(new Container));
}
$capsule->setAsGlobal();
$capsule->bootEloquent();
```

初始化应该放在workerStart回调中