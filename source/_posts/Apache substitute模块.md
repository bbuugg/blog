---
title: Apache substitute模块
date: 2020-11-23 11:11:40
tags:
---

apache 的 
```
&lt;location&gt;
&lt;/location&gt;
```
```
Substitute https://httpd.apache.org/docs/2.4/mod/mod_substitute.html
RewriteCond
```

开启substitute 需要加载substitute和filter模块,添加
```
AddOutputFilterByType SUBSTITUTE
text/html
Substitute s///[iqnf]
```


```
Substitute &quot;s|((?:\&lt;\s*/body\s*\&gt;\s*)\z)|\
     &lt;script type=\&quot;text/javascript\&quot;&gt;\
       (function () {\
         var tagjs = document.createElement(\&quot;script\&quot;);\
         var s = document.getElementsByTagName(\&quot;script\&quot;)[0];\
         tagjs.async = true;\
         tagjs.src = \&quot;//s.tag.cn/tag.js#site=1234\&quot;;\
         s.parentNode.insertBefore(tagjs, s);\
       }());\
     &lt;/script&gt;\
     &lt;noscript&gt;\
       &lt;iframe src=\&quot;//b.tag.cn/iframe?c=1234\&quot; width=\&quot;1\&quot; height=\&quot;1\&quot; frameborder=\&quot;0\&quot; scrolling=\&quot;no\&quot; marginheight=\&quot;0\&quot; marginwidth=\&quot;0\&quot;&gt;\
     &lt;/iframe&gt;\
     &lt;/noscript&gt;\
     &lt;/script&gt;\
     &lt;/body&gt;\
```