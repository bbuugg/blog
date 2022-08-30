---
title: js监听input输入框值的实时变化实例
date: 2020-08-12 12:16:24
tags:
---

情景：监听input输入框值的实时变化实例

解决方法：1.在元素上同时绑定oninput和onporpertychanger事件

实例：

    <script type="text/JavaScript">
    　　function watch(){
    　　consolo.log("in")
    } 
    </script>
	<input type="text"  oninput="watch(event)" onporpertychange="watch(event)" />



2.原生js
```javascript
<script type="text/javascript">
 $(function(){
　　　if("\v"=="v"){//true为IE浏览器，感兴趣的同学可以去搜下，据说是现有最流行的判断浏览器的方法　document.getElementById("a").attachEvent("onporpertychange",function(e){
　　　　console.log("inputting!!");
　　　　}
　　}else{　document.getElementById("a").addEventListener("onporpertychange",function(e){
　　　　console.log("inputting!!");
　　　　}
　　}
});
</script>
<input type="text" id="a"/>
```
3.使用jQuery绑定事件
```javascript
<script type="text/javascript">
 $(function(){
　　$("#a").bind('input porpertychange',function(){
　　　　console.log("e");
　　　　});
　　});
</script>
<input type="text" id="a"/>
```