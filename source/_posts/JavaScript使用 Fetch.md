---
title: JavaScript使用 Fetch
date: 2022-05-22 19:24:21
tags:
---

[Fetch API](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fen-US%2Fdocs%2FWeb%2FAPI%2FFetch_API) 提供了一个 JavaScript接口，用于访问和操纵HTTP管道的部分，例如请求和响应。它还提供了一个全局 [`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)方法，该方法提供了一种简单，合理的方式来跨网络异步获取资源。

这种功能以前是使用  [`XMLHttpRequest`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FXMLHttpRequest)实现的。Fetch提供了一个更好的替代方法，可以很容易地被其他技术使用，例如 [`Service Workers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FServiceWorker_API)。Fetch还提供了单个逻辑位置来定义其他HTTP相关概念，例如CORS和HTTP的扩展。

请注意，`fetch`规范与`jQuery.ajax()`主要有两种方式的不同，牢记：

- 当接收到一个代表错误的 HTTP 状态码时，从 `fetch()`返回的 Promise **不会被标记为 reject，** 即使该 HTTP 响应的状态码是 404 或 500。相反，它会将 Promise 状态标记为 resolve （但是会将 resolve 的返回值的 `ok` 属性设置为 false ），仅当网络故障时或请求被阻止时，才会标记为 reject。
- 默认情况下，`fetch` **不会从服务端发送或接收任何 cookies**, 如果站点依赖于用户 session，则会导致未经认证的请求（要发送 cookies，必须设置 [credentials](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch%23%E5%8F%82%E6%95%B0) 选项）。自从2017年8月25日后，默认的credentials政策变更为`same-origin`Firefox也在61.0b13中改变默认值

## 进行 fetch 请求 [参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E8%BF%9B%E8%A1%8C_fetch_%E8%AF%B7%E6%B1%82)

一个基本的 fetch请求设置起来很简单。看看下面的代码：



```jsx
fetch('http://example.com/movies.json')
  .then(function(response) {
    return response.json();
  })
  .then(function(myJson) {
    console.log(myJson);
  });
```

这里我们通过网络获取一个JSON文件并将其打印到控制台。最简单的用法是只提供一个参数用来指明想`fetch()`到的资源路径，然后返回一个包含响应结果的promise(一个 [`Response`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse) 对象)。

当然它只是一个 HTTP 响应，而不是真的JSON。为了获取JSON的内容，我们需要使用  [`json()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2Fjson)方法（在[`Body`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody)mixin 中定义，被 [`Request`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest) 和 [`Response`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse) 对象实现）。

**注意**：Body mixin 还有其他相似的方法，用于获取其他类型的内容。参考 [Body](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23Body)。

最好使用符合[内容安全策略 (CSP)](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FSecurity%2FCSP%2FCSP_policy_directives)的链接而不是使用直接指向资源地址的方式来进行Fetch的请求。

### 支持的请求参数[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E6%94%AF%E6%8C%81%E7%9A%84%E8%AF%B7%E6%B1%82%E5%8F%82%E6%95%B0)

`fetch()` 接受第二个可选参数，一个可以控制不同配置的 `init` 对象：

参考 [`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)，查看所有可选的配置和更多描述。



```jsx
// Example POST method implementation:

postData('http://example.com/answer', {answer: 42})
  .then(data => console.log(data)) // JSON from `response.json()` call
  .catch(error => console.error(error))

function postData(url, data) {
  // Default options are marked with *
  return fetch(url, {
    body: JSON.stringify(data), // must match 'Content-Type' header
    cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
    credentials: 'same-origin', // include, same-origin, *omit
    headers: {
      'user-agent': 'Mozilla/4.0 MDN Example',
      'content-type': 'application/json'
    },
    method: 'POST', // *GET, POST, PUT, DELETE, etc.
    mode: 'cors', // no-cors, cors, *same-origin
    redirect: 'follow', // manual, *follow, error
    referrer: 'no-referrer', // *client, no-referrer
  })
  .then(response => response.json()) // parses response to JSON
}
```

### 发送带凭据的请求[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E5%8F%91%E9%80%81%E5%B8%A6%E5%87%AD%E6%8D%AE%E7%9A%84%E8%AF%B7%E6%B1%82)

为了让浏览器发送包含凭据的请求（即使是跨域源），要将`credentials: 'include'`添加到传递给 `fetch()`方法的`init`对象。



```rust
fetch('https://example.com', {
  credentials: 'include'  
})
```

如果你只想在请求URL与调用脚本位于同一起源处时发送凭据，请添加`credentials: 'same-origin'`。



```php
// The calling script is on the origin 'https://example.com'

fetch('https://example.com', {
  credentials: 'same-origin'  
})
```

要改为确保浏览器不在请求中包含凭据，请使用`credentials: 'omit'`。



```rust
fetch('https://example.com', {
  credentials: 'omit'  
})
```

### 上传 JSON 数据[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E4%B8%8A%E4%BC%A0_JSON_%E6%95%B0%E6%8D%AE)

使用 [`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)  POST JSON数据



```jsx
var url = 'https://example.com/profile';
var data = {username: 'example'};

fetch(url, {
  method: 'POST', // or 'PUT'
  body: JSON.stringify(data), // data can be `string` or {object}!
  headers: new Headers({
    'Content-Type': 'application/json'
  })
}).then(res => res.json())
.catch(error => console.error('Error:', error))
.then(response => console.log('Success:', response));
```

### 上传文件[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E4%B8%8A%E4%BC%A0%E6%96%87%E4%BB%B6)

可以通过HTML`<input type="file" />`元素，[`FormData()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFormData%2FFormData) 和[`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)上传文件。



```jsx
var formData = new FormData();
var fileField = document.querySelector("input[type='file']");

formData.append('username', 'abc123');
formData.append('avatar', fileField.files[0]);

fetch('https://example.com/profile/avatar', {
  method: 'PUT',
  body: formData
})
.then(response => response.json())
.catch(error => console.error('Error:', error))
.then(response => console.log('Success:', response));
```

### 上传多个文件[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E4%B8%8A%E4%BC%A0%E5%A4%9A%E4%B8%AA%E6%96%87%E4%BB%B6)

可以通过HTML`<input type="file" mutiple/>`元素，[`FormData()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFormData%2FFormData) 和[`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)上传文件。



```jsx
var formData = new FormData();
var photos = document.querySelector("input[type='file'][multiple]");

formData.append('title', 'My Vegas Vacation');
formData.append('photos', photos.files);

fetch('https://example.com/posts', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(response => console.log('Success:', JSON.stringify(response)))
.catch(error => console.error('Error:', error));
```

### 检测请求是否成功[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E6%A3%80%E6%B5%8B%E8%AF%B7%E6%B1%82%E6%98%AF%E5%90%A6%E6%88%90%E5%8A%9F)

如果遇到网络故障，[`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch) promise 将会 reject，带上一个 [`TypeError`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FJavaScript%2FReference%2FGlobal_Objects%2FTypeError) 对象。虽然这个情况经常是遇到了权限问题或类似问题——比如 404 不是一个网络故障。想要精确的判断 `fetch()` 是否成功，需要包含 promise resolved 的情况，此时再判断 [`Response.ok`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Fok) 是不是为 true。类似以下代码：



```jsx
fetch('flowers.jpg').then(function(response) {
  if(response.ok) {
    return response.blob();
  }
  throw new Error('Network response was not ok.');
}).then(function(myBlob) { 
  var objectURL = URL.createObjectURL(myBlob); 
  myImage.src = objectURL; 
}).catch(function(error) {
  console.log('There has been a problem with your fetch operation: ', error.message);
});
```

### 自定义请求对象[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E8%87%AA%E5%AE%9A%E4%B9%89%E8%AF%B7%E6%B1%82%E5%AF%B9%E8%B1%A1)

除了传给 `fetch()` 一个资源的地址，你还可以通过使用 [`Request()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest%2FRequest) 构造函数来创建一个 request 对象，然后再作为参数传给 `fetch()`：



```jsx
var myHeaders = new Headers();

var myInit = { method: 'GET',
               headers: myHeaders,
               mode: 'cors',
               cache: 'default' };

var myRequest = new Request('flowers.jpg', myInit);

fetch(myRequest).then(function(response) {
  return response.blob();
}).then(function(myBlob) {
  var objectURL = URL.createObjectURL(myBlob);
  myImage.src = objectURL;
});
```

`Request()` 和 `fetch()` 接受同样的参数。你甚至可以传入一个已存在的 request 对象来创造一个拷贝：



```csharp
var anotherRequest = new Request(myRequest,myInit);
```

这个很有用，因为 request 和 response bodies 只能被使用一次（译者注：这里的意思是因为设计成了 stream 的方式，所以它们只能被读取一次）。创建一个拷贝就可以再次使用 request/response 了，当然也可以使用不同的 `init` 参数。

**注意**：[`clone()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest%2Fclone) 方法也可以用于创建一个拷贝。它在语义上有一点不同于其他拷贝的方法。其他方法（比如拷贝一个 response）中，如果 request 的 body 已经被读取过，那么将执行失败，然而 `clone()` 则不会失败。

## Headers[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23Headers)

使用 [`Headers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FHeaders) 的接口，你可以通过 [`Headers()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FHeaders%2FHeaders) 构造函数来创建一个你自己的 headers 对象。一个 headers 对象是一个简单的多名值对：



```go
var content = "Hello World";
var myHeaders = new Headers();
myHeaders.append("Content-Type", "text/plain");
myHeaders.append("Content-Length", content.length.toString());
myHeaders.append("X-Custom-Header", "ProcessThisImmediately");
```

也可以传一个多维数组或者对象字面量：



```cpp
myHeaders = new Headers({
  "Content-Type": "text/plain",
  "Content-Length": content.length.toString(),
  "X-Custom-Header": "ProcessThisImmediately",
});
```

它的内容可以被获取：



```cpp
console.log(myHeaders.has("Content-Type")); // true
console.log(myHeaders.has("Set-Cookie")); // false
myHeaders.set("Content-Type", "text/html");
myHeaders.append("X-Custom-Header", "AnotherValue");

console.log(myHeaders.get("Content-Length")); // 11
console.log(myHeaders.getAll("X-Custom-Header")); // ["ProcessThisImmediately", "AnotherValue"]

myHeaders.delete("X-Custom-Header");
console.log(myHeaders.getAll("X-Custom-Header")); // [ ]
```

虽然一些操作只能在 [`ServiceWorkers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FServiceWorker_API) 中使用，但是它提供了更方便的操作 Headers 的 API。

如果使用了一个不合法的HTTP Header属性名，那么Headers的方法通常都抛出 TypeError 异常。如果不小心写入了一个不可写的属性，也会抛出一个 TypeError 异常。除此以外的情况，失败了并不抛出异常。例如：



```cpp
var myResponse = Response.error();
try {
  myResponse.headers.set("Origin", "http://mybank.com");
} catch(e) {
  console.log("Cannot pretend to be a bank!");
}
```

最佳实践是在使用之前检查 content type 是否正确，比如：



```jsx
fetch(myRequest).then(function(response) {
  if(response.headers.get("content-type") === "application/json") {
    return response.json().then(function(json) {
      // process your JSON further
    });
  } else {
    console.log("Oops, we haven't got JSON!");
  }
});
```

### Guard[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23Guard)

由于 Headers 可以在 request 请求中被发送或者在 response 请求中被接收，并且规定了哪些参数是可写的，Headers 对象有一个特殊的 guard 属性。这个属性没有暴露给 Web，但是它影响到哪些内容可以在 Headers 对象中被操作。

可能的值如下：

- `none`：默认的
- `request`：从 request 中获得的 headers（[`Request.headers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest%2Fheaders)）只读
- `request-no-cors`：从不同域（[`Request.mode`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest%2Fmode) `no-cors`）的 request 中获得的 headers 只读
- `response`：从 response 中获得的 headers（[`Response.headers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Fheaders)）只读
- `immutable`：在 ServiceWorkers 中最常用的，所有的 headers 都只读。

**注意**：你不可以添加或者修改一个 guard 属性是 `request` 的 Request Headers 的 `Content-Length` 属性。同样地，插入 `Set-Cookie` 属性到一个 response headers 是不允许的，因此 ServiceWorkers 是不能给合成的 Response 的 headers 添加一些 cookies。

## Response 对象[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23Response_%E5%AF%B9%E8%B1%A1)

如上述, [`Response`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse) 实例是在 `fetch()` 处理完promises之后返回的。

你会用到的最常见的response属性有:

- [`Response.status`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Fstatus) — 整数(默认值为200) 为response的状态码.
- [`Response.statusText`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2FstatusText) — 字符串(默认值为"OK"),该值与HTTP状态码消息对应.
- [`Response.ok`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Fok) — 如上所示, 该属性是来检查response的状态是否在200-299(包括200,299)这个范围内.该属性返回一个[`Boolean`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBoolean)值.

它的实例也可用通过 JavaScript 来创建, 但只有在[`ServiceWorkers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FServiceWorker_API)中才真正有用,当使用[`respondWith()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetchEvent%2FrespondWith)方法并提供了一个自定义的response来接受request时:



```jsx
var myBody = new Blob();

addEventListener('fetch', function(event) {
  event.respondWith(new Response(myBody, {
    headers: { "Content-Type" : "text/plain" }
  });
});
```

[`Response()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2FResponse) 构造方法接受两个可选参数—response的数据体和一个初始化对象(与[`Request()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest%2FRequest)所接受的init参数类似.)

**注意**: 静态方法[`error()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Ferror)只是返回了一个错误的response. 与此类似地, [`redirect()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse%2Fredirect) 只是返回了一个可以重定向至某URL的response. 这些也只与Service Workers才有关。

## Body[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23Body)

不管是请求还是响应都能够包含body对象. body也可以是以下任意类型的实例.

- [`ArrayBuffer`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FArrayBuffer)
- [`ArrayBufferView`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FArrayBufferView) (Uint8Array等)
- [`Blob`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBlob)/File
- string
- [`URLSearchParams`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FURLSearchParams)
- [`FormData`]([https://developer.mozilla.org/zh-CN/docs/Web/API/FormData](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFormData) "FormData 接口提供了一种表示表单数据的键值对的构造方式，经过它的数据可以使用 XMLHttpRequest.send() 方法送出，本接口和此方法都相当简单直接。如果送出时的编码类型被设为 "multipart/form-data"，它会使用和表单一样的格式。")

[`Body`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody) 类定义了以下方法 (这些方法都被 [`Request`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest) 和[`Response`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse)所实现)以获取body内容. 这些方法都会返回一个被解析后的[`Promise`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FPromise)对象和数据.

- [`arrayBuffer()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2FarrayBuffer)
- [`blob()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2Fblob)
- [`json()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2Fjson)
- [`text()`]([https://developer.mozilla.org/zh-CN/docs/Web/API/Body/text](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2Ftext) "Body混入的 text() 方法提供了一个可供读取的"返回流", ——它返回一个包含USVString对象 (text)的Promise对象，返回结果的编码为UTF-8。")
- [`formData()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FBody%2FformData)

比起XHR来，这些方法让非文本化的数据使用起来更加简单。

请求体可以由传入body参数来进行设置:



```dart
var form = new FormData(document.getElementById('login-form'));
fetch("/login", {
  method: "POST",
  body: form
})
```

request和response（包括`fetch()` 方法）都会试着自动设置`Content-Type`。如果没有设置`Content-Type`值，发送的请求也会自动设值。

## 特性检测[参考](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FFetch_API%2FUsing_Fetch%23%E7%89%B9%E6%80%A7%E6%A3%80%E6%B5%8B)

Fetch API 的支持情况，可以通过检测[`Headers`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FHeaders), [`Request`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FRequest), [`Response`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FResponse) 或 [`fetch()`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FGlobalFetch%2Ffetch)是否在[`Window`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FWindow) 或 [`Worker`](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.mozilla.org%2Fzh-CN%2Fdocs%2FWeb%2FAPI%2FWorker) 域中。例如：

```ruby
if(self.fetch) {
    // run my fetch request here
} else {
    // do something with XMLHttpRequest?
}
```


链接：https://www.jianshu.com/p/e18ced22cfaa