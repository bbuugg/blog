---
title: jquery监听滚动事件
date: 2020-07-10 18:56:16
tags:
---

```javascript
 $(document).scroll(function() {
        var scroH = $(document).scrollTop();  //滚动高度
        var viewH = $(window).height();  //可见高度 
        var contentH = $(document).height();  //内容高度
        if(scroH &gt;100){  //距离顶部大于100px时
        }
        if (contentH - (scroH + viewH) &lt;= 100){  //距离底部高度小于100px
        }  
        if (contentH = (scroH + viewH)){  //滚动条滑到底部啦
        }  
    });
```
————————————————
版权声明：本文为CSDN博主「哈哈哦0」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_29207823/java/article/details/81565160