---
title: 解决浏览器跨域限制方案之JSONP
date: 2022-08-10 13:51:17
tags:
---

## 一.什么是JSONP

![](https://ask.qcloudimg.com/http-save/yehe-2832581/twqcwh2u5x.gif)

JSONP即：JSON with Padding，是一种解决因浏览器跨域限制不允许访问跨域资源的方法。
 JSONP是一个非官方的协议，它允许在[服务器](https://cloud.tencent.com/product/cvm?from=10680)端返回[javascript](https://cloud.tencent.com/product/sms?from=10680)标签到浏览器，在浏览器端通过调用javascript函数的形式实现访问跨域资源或数据。

## 二.JSONP和JSON的关系

JSONP是一种<u>解决因浏览器跨域限制不允许访问跨域资源的方法</u>；而JSON是一种<u>数据格式</u>，与xml类似。
 虽然二者在字面上都含有关键字“JSON”，但实际上他们之间没有任何关系。
 通过JSONP获取到的跨域数据是javascript对象，而非JSON对象，所以避免了数据解析这个过程。

## 三.JSONP的原理

本质上来讲，JSONP解决访问跨域资源的方法，与直接使用`<script>`标签引用资源是一样的。
 原因在于：使用JSONP访问跨域数据时，就是需要在DOM中动态创建`<script>`标签，并设置src属性访问指定资源。
 差别在于：通过JSONP获取到的返回数据是一个函数调用，数据以参数的形式传递给函数；而`<script>`标签返回的是引用的资源内容。

## 四.实战示例

### 1.前端代码

```javascript
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
</head>
<body>
    <h2>验证使用JSONP方式发送跨域请求</h2>
    <div>
        <input type="button" value="发送请求" onclick="ajaxJsonp()">
    </div>
</body>
<script type="text/javascript">
    // 前端通过动态创建javascript标签的方式发送请求
    function ajaxJsonp() {
        var url = "http://localhost:8081/jsonp?callback=jsonpcall";
        var script = document.createElement('script');
        script.setAttribute("type","text/javascript");
        script.src = url;
        document.body.appendChild(script);
    }

    // jsonp返回数据时调用的函数,数据以参数形式传递
    function jsonpcall(data) {
        console.log("do response jsonp data");
        console.log(data);
    }
</script>
</html>
```

### 2.服务端代码

```javascript
/** * 使用JSONP方式处理跨域GET请求 * @param req * @param resp * @param callback 回调函数名称 * @return */
@RequestMapping(value = "/jsonp", method = RequestMethod.GET)
@ResponseBody
public Object testAjaxJsonp(HttpServletRequest req, HttpServletResponse resp,
        @RequestParam("callback") String callback) {
    JSONObject json = new JSONObject();
    json.put("name", "jsonp");
    json.put("pwd", "");

    // 将数据作为函数的参数返回给浏览器,如: jsonpcall({"name":"jsonp","pwd":""})
    return new StringBuffer().append(callback).append("(").append(json).append(")");
}
```

【参考】
 http://www.nowamagic.net/librarys/veda/detail/224 JSONP跨域的原理解析
 http://www.xiaoxiaozi.com/2011/11/25/2239/ JSONP与POST方式请求
 http://www.cnblogs.com/dowinning/archive/2012/04/19/json-jsonp-jquery.html 说说JSON和JSONP
 http://www.cnblogs.com/chopper/archive/2012/03/24/2403945.html 深入浅出JSONP--解决ajax跨域问题

[解决浏览器跨域限制方案之JSONP - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1504166)