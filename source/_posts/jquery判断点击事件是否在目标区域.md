---
title: jquery判断点击事件是否在目标区域
date: 2021-03-30 10:20:03
tags:
---

很多时候需要在鼠标点击非目标区域div将目标div隐藏的效果，这是需要判断点击事件是否在目标区域内

jquery的实现方法是：(最近更新,未测)

```
$(document).click(function(e){ 
        e = window.event || e; // 兼容IE7
        obj = $(e.srcElement || e.target);
          if ($(obj).is(&quot;#elem,#elem *&quot;)) { 
           // alert('内部区域'); 
        } else {
                alert('你的点击不在目标区域');
        } 
});```

这样就可以进行其他效果的操作了,另外一种类似思路:jquery判断点击区域 隐藏/显示其他区域

原始写法:(不兼容ff)
```
$(document).click(function(){ 
          if ($(event.srcElement).is(&quot;#elem,#elem *&quot;)) { 
           // alert('内部区域'); 
          } else {
                alert('你的点击不在目标区域');
          } 
});
```
 
转载请注明：半叶寒羽 » jquery判断点击事件是否在目标区域