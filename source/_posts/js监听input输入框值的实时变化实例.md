---
title: js监听input输入框值的实时变化实例
date: 2020-08-12 12:16:24
tags:
---

情景：监听input输入框值的实时变化实例

解决方法：1.在元素上同时绑定oninput和onporpertychanger事件

实例：

    &lt;script type=&quot;text/JavaScript&quot;&gt;
    　　function watch(){
    　　consolo.log(&quot;in&quot;)
    } 
    &lt;/script&gt;
	&lt;input type=&quot;text&quot;  oninput=&quot;watch(event)&quot; onporpertychange=&quot;watch(event)&quot; /&gt;



2.原生js
```javascript
&lt;script type=&quot;text/javascript&quot;&gt;
 $(function(){
　　　if(&quot;\v&quot;==&quot;v&quot;){//true为IE浏览器，感兴趣的同学可以去搜下，据说是现有最流行的判断浏览器的方法　document.getElementById(&quot;a&quot;).attachEvent(&quot;onporpertychange&quot;,function(e){
　　　　console.log(&quot;inputting!!&quot;);
　　　　}
　　}else{　document.getElementById(&quot;a&quot;).addEventListener(&quot;onporpertychange&quot;,function(e){
　　　　console.log(&quot;inputting!!&quot;);
　　　　}
　　}
});
&lt;/script&gt;
&lt;input type=&quot;text&quot; id=&quot;a&quot;/&gt;
```
3.使用jQuery绑定事件
```javascript
&lt;script type=&quot;text/javascript&quot;&gt;
 $(function(){
　　$(&quot;#a&quot;).bind('input porpertychange',function(){
　　　　console.log(&quot;e&quot;);
　　　　});
　　});
&lt;/script&gt;
&lt;input type=&quot;text&quot; id=&quot;a&quot;/&gt;
```