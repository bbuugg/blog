---
title: PHP如何爬取页面数据
date: 2022-05-11 22:57:41
tags:
---

# 前提

PHP作为世界上最好的语言，爬页面当然不在话下，官方提供了解析DOM的类DOMDocument和XPATH相关的类DOMXPath，使用起来方便快速，但是对于一些不标准的页面可能会出现各种报错。所以推荐下面一款包，虽然依然是使用上面提到的两个类，但是却做了许多容错处理

```shell
composer require voku/simple_html_dom
```

packagist : https://packagist.org/packages/voku/simple_html_dom

使用说明可以参考文档，但是这里还是有必要记录一下

# 使用

## 引入文件

```php
<?php

use voku\helper\HtmlDomParser;

require_once "./vendor/autoload.php";
```

## 解析html

```
$html = curl($url);
$dom = HtmlDomParser::str_get_html($html);
```

## 查找元素

```
$elements = $dom->findMulti('.class');
$element = $dom->findOne('#id')
```

这个返回值是一个可以迭代的对象，所以需要迭代它

## 迭代元素

```
foreach($elements as $element) {
	var_dump($element);
}
```

# 示例

```php
$html = <<<EOT
<ul id="example-list">
	<li class="list">
		第一行
	</li>
	<li class="list">
		第二行
	</li>
	<li id="end-li">
		第二行
	</li>
</ul>
EOT;
$dom = HtmlDomParser::str_get_html($html);
foreach($dom->findMulti('.list')->getIterator() as $li) {
    var_dump($li->attr['class']);
}
$ul = $dom->findOne('#example-list #end-li');  // 例子
var_dump($ul->attr['id']);
```

# 注意

爬取页面要尽量伪装自己，防止被禁止

```php
function curl($url)
{
    $ch = curl_init($url);
    $headers = [
        'DNT' => 1,
        'Referer' => 'https://www.1kmb.com/',
        'sec-ch-ua' => '" Not A;Brand";v="99", "Chromium";v="100", "Microsoft Edge";v="100"',
        'sec-ch-ua-mobile' => '?0',
        'sec-ch-ua-platform' => '"Windows"',
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36 Edg/100.0.1185.50
]'];

    curl_setopt_array($ch, [
        CURLOPT_HTTPHEADER => $headers,
        CURLOPT_HEADER => false,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_SSL_VERIFYHOST => false,
        CURLOPT_SSL_VERIFYPEER => false,
    ]);

    $r = curl_exec($ch);
    curl_close($ch);
    return $r;
}
```

尽可能让服务端认为这是一次正常请求。