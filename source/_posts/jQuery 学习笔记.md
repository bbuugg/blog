---
title: jQuery 学习笔记
date: 2020-11-19 20:20:36
tags:
---

# 去除表单空值
```
$(&#039;input&#039;, &#039;#submForm&#039;).each(function(){
	$(this).val() == &quot;&quot; &amp;&amp; $(this).remove();
})
```
或者
```
$(&#039;input:text[value=&quot;&quot;]&#039;, &#039;#submForm&#039;).remove();
```

# 串行化
```
var serialized = $(&#039;#submForm&#039;).serialize()
```

获取表单所有值$(&#039;form&#039;).serialize()

# 过滤
```
$(document).ready(function () {
    $(&#039;#myForm&#039;).submit(function () {
	$(this).find(&quot;:input&quot;).filter(function () {
        return $.trim(this.value).length &gt; 0
    }).serialize();
    alert(&#039;JavaScript done&#039;);
    });
});
```

$.trim() 函数用于去除字符串两端的空白字符