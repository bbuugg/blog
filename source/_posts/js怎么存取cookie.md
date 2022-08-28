---
title: js怎么存取cookie
date: 2020-08-12 11:26:27
tags:
---

### js存入cookie

    function Setcookie (name, value){ 
        //设置名称为name,值为value的Cookie
        var expdate = new Date();   //初始化时间
        expdate.setTime(expdate.getTime() + 30 * 60 * 1000);   //时间单位毫秒
        document.cookie = name+&amp;quot;=&amp;quot;+value+&amp;quot;;expires=&amp;quot;+expdate.toGMTString()+&amp;quot;;path=/&amp;quot;;
 
   //即document.cookie= name+&amp;quot;=&amp;quot;+value+&amp;quot;;path=/&amp;quot;;  时间默认为当前会话可以不要，但路径要填写，因为JS的默认路径是当前页，如果不填，此cookie只在当前页面生效！
}
### js取出cookie

    function getCookie(c_name){
    //判断document.cookie对象里面是否存有cookie
    if (document.cookie.length&amp;gt;0){
      c_start=document.cookie.indexOf(c_name + &amp;quot;=&amp;quot;)
    	//如果document.cookie对象里面有cookie则查找是否有指定的cookie，如果有则返回指定的cookie值，如果没有则返回空字符串
      if (c_start!=-1){ 
        c_start=c_start + c_name.length+1 
        c_end=document.cookie.indexOf(&amp;quot;;&amp;quot;,c_start)
        if (c_end==-1) c_end=document.cookie.length
        return unescape(document.cookie.substring(c_start,c_end))
        } 
      }
    return &amp;quot;&amp;quot;
    }

https://blog.csdn.net/minolk/article/details/80540750

### jq存取cookie
首先引入下面的文件
```javascript
/*! jquery.cookie v1.4.1 | MIT */
!function(a){&amp;quot;function&amp;quot;==typeof define&amp;amp;&amp;amp;define.amd?define([&amp;quot;jquery&amp;quot;],a):&amp;quot;object&amp;quot;==typeof exports?a(require(&amp;quot;jquery&amp;quot;)):a(jQuery)}(function(a){function b(a){return h.raw?a:encodeURIComponent(a)}function c(a){return h.raw?a:decodeURIComponent(a)}function d(a){return b(h.json?JSON.stringify(a):String(a))}function e(a){0===a.indexOf('&amp;quot;')&amp;amp;&amp;amp;(a=a.slice(1,-1).replace(/\\&amp;quot;/g,'&amp;quot;').replace(/\\\\/g,&amp;quot;\\&amp;quot;));try{return a=decodeURIComponent(a.replace(g,&amp;quot; &amp;quot;)),h.json?JSON.parse(a):a}catch(b){}}function f(b,c){var d=h.raw?b:e(b);return a.isFunction(c)?c(d):d}var g=/\+/g,h=a.cookie=function(e,g,i){if(void 0!==g&amp;amp;&amp;amp;!a.isFunction(g)){if(i=a.extend({},h.defaults,i),&amp;quot;number&amp;quot;==typeof i.expires){var j=i.expires,k=i.expires=new Date;k.setTime(+k+864e5*j)}return document.cookie=[b(e),&amp;quot;=&amp;quot;,d(g),i.expires?&amp;quot;; expires=&amp;quot;+i.expires.toUTCString():&amp;quot;&amp;quot;,i.path?&amp;quot;; path=&amp;quot;+i.path:&amp;quot;&amp;quot;,i.domain?&amp;quot;; domain=&amp;quot;+i.domain:&amp;quot;&amp;quot;,i.secure?&amp;quot;; secure&amp;quot;:&amp;quot;&amp;quot;].join(&amp;quot;&amp;quot;)}for(var l=e?void 0:{},m=document.cookie?document.cookie.split(&amp;quot;; &amp;quot;):[],n=0,o=m.length;o&amp;gt;n;n++){var p=m[n].split(&amp;quot;=&amp;quot;),q=c(p.shift()),r=p.join(&amp;quot;=&amp;quot;);if(e&amp;amp;&amp;amp;e===q){l=f(r,g);break}e||void 0===(r=f(r))||(l[q]=r)}return l};h.defaults={},a.removeCookie=function(b,c){return void 0===a.cookie(b)?!1:(a.cookie(b,&amp;quot;&amp;quot;,a.extend({},c,{expires:-1})),!a.cookie(b))}});
```

#### a)设置新的cookie:

$.cookie('name'，'dumplings');  //设置一个值为'dumplings'的cookie
设置cookie的生命周期
 $.cookie('key', 'value', { expires: 7 }); //设置为7天，默认值：浏览器关闭

#### 设置cookie的域名：
$.cookie('name'，'dumplings', {domain:'qq.com'});   //设置一个值为'dumplings'的在域名'qq.com'的cookie
设置cookie的路径：

$.cookie('name'，'dumplings', {domain:'qq.com'，path:'/'});  
//设置一个值为'dumplings'的在域名'qq.com'的路径为'/'的cookie
#### b)删除cookie

$.removeCookie('name',{ path: '/'}); //path为指定路径，直接删除该路径下的cookie
$.cookie('name',null,{ path: '/'}); //将cookie名为&amp;lsquo;openid&amp;rsquo;的值设置为空，实际已删除
#### c)获取cookie

$.cookie('name')   //dumplings

踩过的坑： 
cookie的域名和路径都很重要，如果没有设置成一致，则会有不同域名下或者不同路径下的同名cookie，为了避免这种情况，建议在设置cookie和删除cookie的时候，配置路径和域名。

https://www.cnblogs.com/hellofangfang/p/9626797.html