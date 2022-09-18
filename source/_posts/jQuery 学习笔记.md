---
title: jQuery 学习笔记
date: 2020-11-19 20:20:36
tags:
---

# 去除表单空值

```
$("input", "#submForm").each(function(){
	$(this).val() == "" && $(this).remove();
})
```

或者

```
$("input:text[value=""]", "#submForm").remove();
```

# 串行化

```
var serialized = $("#submForm").serialize()
```

获取表单所有值$("form").serialize()

# 过滤

```
$(document).ready(function () {
    $("#myForm").submit(function () {
	$(this).find(":input").filter(function () {
        return $.trim(this.value).length > 0
    }).serialize();
    alert("JavaScript done");
    });
});
```

$.trim() 函数用于去除字符串两端的空白字符

# jQuery 监听元素内容变化的方法

> 我们可以用 onchange 事件来完成元素值发生改变触发的监听。但是 onchange 比较适用于`<input>`、`<textarea>`以及 `<select>` 元素,对于 div，span 等元素就不能使用了。

当 $("span").html() 获取的是个空，或者获取的不是自己想要的。原因是当我们获取的时候，元素的内容还没有发生改变，这个时候就需要监听这个 span 内容了。

> 下面举两个小例子

```javascript
$("#test-editormd-view2").bind("DOMNodeInserted", function (e) {
  console.log($(e.target).html());
});
```

```javascript
$("#test-editormd-view2").on("DOMNodeInserted", function () {
  $("#content-loading").remove();
});
```

# ajax 实现文件上传

我在写 jQuery 接口上传文件的时候，遇到一个特头疼的问题，那就是上传图片，刚开始那我以为一个简单的 form 表单就搞定了，没想到写了两个小时都没写出来，心情那个烦躁啊，有一种想砸电脑的冲动，最后那我就用下面的方法实现了这个功能，突然发现好简单，分享给大家！废话不多说，直接上干货，代码走起。。。。

# 代码块

## html 代码段

```
<input type="file" name="photo" id="photo" value="" placeholder="免冠照片">
<input type="button" onclick="postData();" value="下一步" name="" style="width:100px;height:30px;">
```

## jQuery 代码段

```javascript
<script type="text/javascript">
function postData(){
    var formData = new FormData();
    formData.append("photo",$("#photo")[0].files[0]);
    formData.append("service",'App.Passion.UploadFile');
    formData.append("token",token);
    $.ajax({
        url:'http://www.baidu.com/', /*接口域名地址*/
        type:'post',
        data: formData,
        contentType: false,
        processData: false,
        success:function(res){
            console.log(res.data);
            if(res.data["code"]=="succ"){
                alert('成功');
            }else if(res.data["code"]=="err"){
                alert('失败');
            }else{
                console.log(res);
            }
        }
    })
}
```

```javascript
<script>
  $(function()
  {$(".but").click(function () {
    data = new FormData($("#form1")[0]);
    console.log(data);
    // $.post('up.php',{p:2},function(data){
    //    alert(data);
    //  })
    $.ajax({
      url: "up.php",
      type: "POST",
      data: data,
      dataType: "JSON",
      cache: false,
      processData: false, //不处理发送的数据，因为data值是FormData对象，不需要对数据做处理
      contentType: false, //不设置Content-type请求头
    }).done(function (ret) {
      console.log(ret);
    });
  })}
  )
</script>
```

# jquery 判断点击事件是否在目标区域

很多时候需要在鼠标点击非目标区域 div 将目标 div 隐藏的效果，这是需要判断点击事件是否在目标区域内

jquery 的实现方法是：(最近更新,未测)

```javascript
$(document).click(function(e){
        e = window.event || e; // 兼容IE7
        obj = $(e.srcElement || e.target);
          if ($(obj).is("#elem,#elem *")) {
           // alert('内部区域');
        } else {
                alert('你的点击不在目标区域');
        }
});
```

这样就可以进行其他效果的操作了,另外一种类似思路:jquery判断点击区域 隐藏/显示其他区域

原始写法:(不兼容ff)

```javascript
$(document).click(function(){ 
    if ($(event.srcElement).is("#elem,#elem \*")) {
        // alert('内部区域');
    } else {    
        alert('你的点击不在目标区域');
    }    
});
```

# jQuery选择器获取第一个子元素以及带空格的class

jQuery选择器选取第一个子元素

```javascript
$("p:first")
````

jQuery选择器选取HTML 中 class="hov_bg hov2" class中带有空格的这类元素
```javascript
$(".hov_bg.hov2");
```
该选择器可以筛选出同时拥有class="hov_bg hov2"样式的HTML元素

```javascript
$(".hov2");
```

该选择器可以筛选出class="hov2"和class="hov_bg hov2"的元素

例子:

```html
<div class="container">simple</div>
<div class="layer container">complex</div>
<script type="text/javascript">
alert($(".container.layer").html());
</script>
````

class 中带空格不是指一个 class，而是指两种 class 中的任意一种。
下面是详解：

CSS 多类选择器
在上一节中，我们处理了 class 值中包含一个词的情况。在 HTML 中，一个 class 值中可能包含一个词列表，各个词之间用空格分隔。例如，如果希望将一个特定的元素同时标记为重要（important）和警告（warning），就可以写作：

<p class="important warning"> This paragraph is a very important warning. </p>
这两个词的顺序无关紧要，写成 warning important 也可以。
我们假设 class 为 important 的所有元素都是粗体，而 class 为 warning 的所有元素为斜体，class 中同时包含 important 和 warning 的所有元素还有一个银色的背景 。就可以写作：

```CSS
.important {[font-weight](https://www.baidu.com/s?wd=font-weight&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao):bold;}
.warning {[font-weight](https://www.baidu.com/s?wd=font-weight&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao):italic;}
.important.warning {background:silver;}
```

# 监听滚动事件

```javascript
$(document).scroll(function () {
  var scroH = $(document).scrollTop(); //滚动高度
  var viewH = $(window).height(); //可见高度
  var contentH = $(document).height(); //内容高度
  if (scroH > 100) {
    //距离顶部大于100px时
  }
  if (contentH - (scroH + viewH) <= 100) {
    //距离底部高度小于100px
  }
  if ((contentH = scroH + viewH)) {
    //滚动条滑到底部啦
  }
});
```

# jquery 获取所有选中的 checkbox

获取所有 name 为 spCodeId 的 checkbox

```javascript
var spCodesTemp = "";
$("input:checkbox[name=spCodeId]:checked").each(function (i) {
  if (0 == i) {
    spCodesTemp = $(this).val();
  } else {
    spCodesTemp += "," + $(this).val();
  }
});
$("#txt_spCodes").val(spCodesTemp);
```

以类型查找

```javascript
$("input[type='checkbox'][checked]")
```

以名称查找

```javascript
$("input:checkbox[name='the checkbox name']:checked")
```

//如果是在某一些标签下查找的话，为了防止查找到 table #tbTemplate 元素以外的 checkbox：checked，我们可以这样来限制：

```javascript
$("table#tbTemplate input:checkbox[name='the checkbox name']:checked")
```  

原生态的用法

```JavaScript
$($("table#tbTemplate input[type='checkbox']"),function(i,checkbox){
     if(checkbox.checked){
          // keep the state. or log this checked......
     }
});
```

判断多选框是否有选中

```javascript
if (!$("input[type='checkbox']").is(':checked')) { 
    $('#sitetable').hide(); 
}
```

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta
      name="viewport"
      content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"
    />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Document</title>
  </head>
  <body>
    <input type="checkbox" name="use" data-id="1" />
    <input type="checkbox" name="usr" data-id="3" />
    <input type="checkbox" name="use" data-id="5" />
    <input type="checkbox" name="ser" data-id="7" />
    <input type="checkbox" name="uer" data-id="9" />
    <input type="button" value="选择" />
    <script src="/static/admin/js/core/jquery.3.2.1.min.js"></script>
    <script>
      $(() => {
        $("input:button").click(() => {
          $("input:checkbox:checked").each((e, w) => {
            console.log($(w).attr("data-id"));
          });
        });
      });
    </script>
  </body>
</html>
```
