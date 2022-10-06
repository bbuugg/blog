---
title: PHP限速下载
date: 2020-10-29 20:38:50
tags:
---

```php
<?php
$arr = [
    "b798abe6e1b1318ee36b0dcb3fb9e4d3" => ["./img/img.jpg", "img.jpg"],
    "4cf350692a4a3bb54d13daacfe8c683b" => ["./img/小明.chw", "小明.chw"]
];

header("Content-type:application/octet-stream");
header("Content-disposition:attachment;filename=" . $arr[$_GET["file"]][1]);
//    readfile($arr[$_GET["file"]][0]);
$handler = fopen($arr[$_GET["file"]][0], "rb");
while (!feof($handler)) {
    $files = fread($handler, 100); //限速下载
//        flush();
    print_r($files);
    usleep(20);
}
fclose($handler);
```