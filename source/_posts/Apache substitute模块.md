---
title: Apache substitute模块
date: 2020-11-23 11:11:40
tags:
---

apache 的 
```
<location>
</location>
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

<!-- more -->

```
Substitute "s|((?:\<\s*/body\s*\>\s*)\z)|\
     <script type=\"text/javascript\">\
       (function () {\
         var tagjs = document.createElement(\"script\");\
         var s = document.getElementsByTagName(\"script\")[0];\
         tagjs.async = true;\
         tagjs.src = \"//s.tag.cn/tag.js#site=1234\";\
         s.parentNode.insertBefore(tagjs, s);\
       }());\
     </script>\
     <noscript>\
       <iframe src=\"//b.tag.cn/iframe?c=1234\" width=\"1\" height=\"1\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\">\
     </iframe>\
     </noscript>\
     </script>\
     </body>\
```