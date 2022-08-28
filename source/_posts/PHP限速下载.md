---
title: PHP限速下载
date: 2020-10-29 20:38:50
tags:
---

```
&lt;?php

$arr = [
    &#039;b798abe6e1b1318ee36b0dcb3fb9e4d3&#039; =&gt; [&#039;./img/img.jpg&#039;, &#039;img.jpg&#039;],
    &#039;4cf350692a4a3bb54d13daacfe8c683b&#039; =&gt; [&#039;./img/小明.chw&#039;, &#039;小明.chw&#039;]
];


header(&#039;Content-type:application/octet-stream&#039;);
header(&#039;Content-disposition:attachment;filename=&#039; . $arr[$_GET[&#039;file&#039;]][1]);
//    readfile($arr[$_GET[&#039;file&#039;]][0]);
$handler = fopen($arr[$_GET[&#039;file&#039;]][0], &#039;rb&#039;);
while (!feof($handler)) {
    $files = fread($handler, 100); //限速下载
//        flush();
    print_r($files);
    usleep(20);
}
fclose($handler);
```