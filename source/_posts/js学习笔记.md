---
title: js学习笔记
date: 2020-09-26 22:53:26
tags:
---

# 自定义函数
## in_array
```javascript
function in_array(stringToSearch, arrayToSearch) {
	for (s = 0; s < arrayToSearch.length; s++) {
		thisEntry = arrayToSearch[s].toString();
		if (thisEntry == stringToSearch) {
			return true;
		}
	}
	return false;
}
```
	

##判断文件后缀
```javascript
var location=$("input[name='file']").val();  
     var point = location.lastIndexOf(".");  
      
     var type = location.substr(point);  
     if(type==".jpg"||type==".gif"||type==".JPG"||type==".GIF"){  
               
     } 
```


> 其他方法

1. jquery:validate /datatable  
2. document.forms[formName]\[inputName]
3. datatable.api.ajax.reload()
4. window.location.reload()
5. $('.row').find('td:eq(1)').html()
6. trim函数可以去掉空格
7. 事件委托：$('父节点').on('触发方法','子节点',function(){})  对应off去掉拥有的事件
8. evt.preventDefault() /return false; 取消默认事件
9. JQ对象.bind('事件[多个可以使用空格分割]').triggle('select') 触发选中事件
10. 获取checkbox的选中项：$('input:checkbox[name="box"]:checked')
11. var arr = $('').split('\n') 将字符串使用\n分割为数组
12.stop方法，停止当前运行的动画
13.is方法

# 跳转

```html
<meta http-equiv="refresh" content="3" ; url="index.html">
```

```js
window.location.href="index.html"
$('location').attr('href','index.html')
document.referrer  //获取referer
setTimeout("javascrpt:location.href='index.html'",5000) //定时跳转
window.location.search  //可以获取地址栏的query_string
window.history.go(-1) / back(-1)  //返回上一页
<a onclick="javascript:history.go(-1)">
window.navigate('http://www.1kmb.com') //使用navigate方式跳转
window.open('http://www.1kmb.com') //打开新网页
window.location.href="http://www.1kmb.com/index.php?ref="+window.location.href
location.reload([bForceGet]) //bForceGet可选，默认FALSE，用HTTP头If-Modified-Since来检测服务器上的文档是否已经改变，如果改变会重新下载文档，否则从客户端缓存里取当前页,TRUE则以get方式从服务器获取最新页面，相当于F5刷新
location.replace(URL)
location.assign(LOCATION)
document.execCommand('Refresh')
document.URL=location.href
$(document).attr('location',document.referer)
```

# 事件
`dblclick()` jquery双击事件

.bind()

```javascript
//绑定多个选择器
$(document).on('click','#header a,#sidebar a',function(){
})
//绑定多个事件
$('table tr').on({
    mouseenter:function(){
        
    },
    mouseleave:function(){
        
    },
    click:function(){
        
    }
},'td')
//同时绑定多个选择器和多个事件
$(document).on({
     mouseenter:function(){
        
    },
    mouseleave:function(){
        
    },
    click:function(){
        
    },
},'')
```

```javascript
<script>
$( document ) .ready ( function(){
$( '.comments .active ' ).css( "point
er-events " , " none" )
}）;
</script>
```




layer.js


#js-监听页面滚动

##一、原生js通过window.onscroll监听
```javascript
window.onscroll = function() {
  //为了保证兼容性，这里取两个值，哪个有值取哪一个
  //scrollTop就是触发滚轮事件时滚轮的高度
  var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
  console.log("滚动距离" + scrollTop);
}
```
##二、Jquery通过$(window).scroll()监听

```javascript
$(window).scroll(function() {
  //为了保证兼容性，这里取两个值，哪个有值取哪一个
  //scrollTop就是触发滚轮事件时滚轮的高度
  var scrollTop = document.documentElement.scrollTop || document.body.scrollTop;
  console.log("滚动距离" + scrollTop);
})
```
##Javascript获取一个盒子的宽和高；

```javascript
var width = document.getElementById("box2").offsetWidth;//宽度
var height = document.getElementById("box2").offsetHeight;//
```

##jq判断元素是否存在于数组中
```javascript
$.inArray(element,array);
```
存在返回元素下标，否则返回-1，可以使用`arr.splice($.inArray('test',arr),1);` 删除某一个元素，删除前需要判断元素是否存在否则当数组中只有一个值的时候会删除该值【未测试】。

## jq点击复制

```
<script src="http://libs.baidu.com/jquery/1.9.0/jquery.js"></script>  
    <script src="https://cdn.jsdelivr.net/clipboard.js/1.5.12/clipboard.min.js"></script>  
微信号：<span id="target">xyz2018</span>
<button class="btn" data-clipboard-action="copy" data-clipboard-target="#target" id="copy_btn">    
    点击复制    
</button>   
	
<script>    
    $(document).ready(function(){      
        var clipboard = new Clipboard('#copy_btn');    
        clipboard.on('success', function(e) {    
            alert("微信号复制成功",1500);
            e.clearSelection();    
            console.log(e.clearSelection);    
        });    
    });    
</script>
```