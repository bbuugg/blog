---
title: jQuery 监听元素内容变化的方法
date: 2021-04-03 11:51:45
tags:
---

&gt;我们可以用onchange事件来完成元素值发生改变触发的监听。但是 onchange 比较适用于`&lt;input&gt;`、`&lt;textarea&gt;`以及 `&lt;select&gt;` 元素,对于 div，span等元素就不能使用了。

当 $(&quot;span&quot;).html() 获取的是个空，或者获取的不是自己想要的。原因是当我们获取的时候，元素的内容还没有发生改变，这个时候就需要监听这个 span 内容了。

&gt;下面举两个小例子

```javascript
$(&quot;#test-editormd-view2&quot;).bind(&quot;DOMNodeInserted&quot;,function(e){
     console.log($(e.target).html());
})
```
```javascript
$('#test-editormd-view2').on('DOMNodeInserted', function () {
	$('#content-loading').remove();
});
```