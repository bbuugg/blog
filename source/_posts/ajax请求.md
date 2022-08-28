---
title: ajax请求
date: 2021-04-02 18:49:14
tags:
---

# javascript

## **XMLHttpRequest 对象**

　　XMLHttpRequest对象是ajax的基础,XMLHttpRequest 用于在后台与服务器交换数据。这意味着可以在不重新加载整个网页的情况下，对网页的某部分进行更新。目前所有浏览器都支持XMLHttpRequest

| 方  法                                                     | 描  述                                                       |
| ---------------------------------------------------------- | ------------------------------------------------------------ |
| abort()                                                    | 停止当前请求                                                 |
| getAllResponseHeaders()                                    | 把HTTP请求的所有响应首部作为键/值对返回                      |
| getResponseHeader("header")                                | 返回指定首部的串值                                           |
| open("method","URL",[asyncFlag],["userName"],["password"]) | 建立对服务器的调用。method参数可以是GET、POST或PUT。url参数可以是相对URL或绝对URL。这个方法还包括3个可选的参数，是否异步，用户名，密码 |
| send(content)                                              | 向服务器发送请求                                             |
| setRequestHeader("header", "value")                        | 把指定首部设置为所提供的值。在设置任何首部之前必须先调用open()。设置header并和请求一起发送 ('post'方法一定要 ) |

post 需要在open后设置header ，需要发送数据直接传递给xhr.send的第一个参数

```
xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
```

关键字：`responseText,` `readyState`, `onreadystatechange`

## Jq的ajax方法

```
$.get('http://www.aaa.com',data,function(data,status){
		if('success' === status){
			console.log(data);	
		}
},'json')
```

`dataType` 可以是`text`,`html`,`xml`,`script`,`json`,`jsonp` 将添加一个 "?callback=?" 到 URL 来规定回调,POST方式类似使用$.post

```js
$.ajax({
	url:'http://www.aaa.com',
	type:'GET',
	dataType:'json',
    data:{'name':'bbb'},
    traditional:true, //如果你想要用传统的方式来序列化数据，那么就设置为 true。请参考工具分类下面的 jQuery.param 方法。
    timeout:'int', //设置请求超时时间（毫秒）。此设置将覆盖全局设置。
    scriptCharset:'string',//只有当请求时 dataType 为 "jsonp" 或 "script"，并且 type 是 "GET" 才会用于强制修改 charset。通常只在本地和远程的内容编码不同时使用。
	async:true, //true为异步
    processData:true, //默认值: true。默认情况下，通过data选项传递进来的数据，如果是一个对象(技术上讲只要不是字符串)，都会处理转化成一个查询字符串，以配合默认内容类型 "application/x-www-form-urlencoded"。如果要发送 DOM 树信息或其它不希望转换的信息，请设置为 false。
    ifModified:false,//仅在服务器数据改变时获取新数据。默认值: false。使用 HTTP 包 Last-Modified 头信息判断。在 jQuery 1.4 中，它也会检查服务器指定的 'etag' 来确定数据没有被修改过。
    global:true, //是否触发全局 AJAX 事件。默认值: true。设置为 false 将不会触发全局 AJAX 事件，如 ajaxStart 或 ajaxStop 可用于控制不同的 Ajax 事件。
    cache:true, //默认值: true，dataType 为 script 和 jsonp 时默认为 false。设置为 false 将不缓存此页面。
    contentType:'applicate/x-www-form-urlencoded', //默认值
    context:document.body, //这个对象用于设置 Ajax 相关回调函数的上下文。也就是说，让回调函数内 this 指向这个对象（如果不设定这个参数，那么 this 就指向调用本次 AJAX 请求时传递的 options 参数）。比如指定一个 DOM 元素作为 context 参数，这样就设置了 success 回调函数的上下文为这个 DOM 元素。
    xhr:function(){
        //需要返回一个 XMLHttpRequest 对象。默认在 IE 下是 ActiveXObject 而其他情况下是 XMLHttpRequest 。用于重写或者提供一个增强的 XMLHttpRequest 对象。这个参数在 jQuery 1.3 以前不可用。
    }
    dataFilter:function(data,Type){
        
    },
    beforeSend:function(XHR){
        
    },
	success:function(e){
	
	},
    error:function(e){
        
    },
    complete:function(XHR, TS){
        //请求完成后回调函数 (请求成功或失败之后均调用)。
    },
    jsonpCallback:'string', //为 jsonp 请求指定一个回调函数名。这个值将用来取代 jQuery 自动生成的随机函数名。这主要用来让 jQuery 生成度独特的函数名，这样管理请求更容易，也能方便地提供回调函数和错误处理。你也可以在想让浏览器缓存 GET 请求的时候，指定这个回调函数名。
    password:'string', //用于响应 HTTP 访问认证请求的密码
})
```

## getScript

```
$(selector).getScript(url,success(response,status))
```

getScript() 方法使用 AJAX 的 HTTP GET 请求获取和执行 JavaScript。 

- *status* - 包含请求的状态（"success"、"notmodified"、"error"、"timeout"、"parsererror"）

fetch

es6新语法fetch().then()

## 一些发送请求后可以执行的方法:

- always():一定会执行
- catch():执行出错时执行(本体 object)
- done():执行成功时执行
- failed():执行出错时执行(服务器拒绝)
- pipe():过滤方法
- progress():当对象生成进度通知时，调用添加处理程序。
- Promise():返回Object(延迟)的Promise（承诺）对象。
- state():确定一个Object（延迟）对象的当前状态。
- then():当（延迟）对象解决，拒绝或仍在进行中时，调用添加处理程序。

>es6 新增fetch().then()

## formData

```
$('#file_upload').on('change',function(){
      var that = this;
      var files = this.files[0];
}

var form = new FormData();
form.append('file',files);
```

onclick="return function(){}" 当function返回true执行默认行为为false不执行

# fetch

```
fetch('https://...', {
    method: 'post',
    body: JSON.stringify(base),
    headers: {
      'Content-Type': 'application/json'
    }
  }).then(function(data) {
})
```