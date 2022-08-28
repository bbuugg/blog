---
title: jQuery+ajax实现文件上传
date: 2021-04-17 15:09:55
tags:
---

我在写jQuery接口上传文件的时候，遇到一个特头疼的问题，那就是上传图片，刚开始那我以为一个简单的form表单就搞定了，没想到写了两个小时都没写出来，心情那个烦躁啊，有一种想砸电脑的冲动，最后那我就用下面的方法实现了这个功能，突然发现好简单，分享给大家！废话不多说，直接上干货，代码走起。。。。

# 代码块

## html代码段

```
&lt;input type=&quot;file&quot; name=&quot;photo&quot; id=&quot;photo&quot; value=&quot;&quot; placeholder=&quot;免冠照片&quot;&gt;
&lt;input type=&quot;button&quot; onclick=&quot;postData();&quot; value=&quot;下一步&quot; name=&quot;&quot; style=&quot;width:100px;height:30px;&quot;&gt;
```

## jQuery代码段

```
&lt;script type=&quot;text/javascript&quot;&gt;
function postData(){
    var formData = new FormData();
    formData.append(&quot;photo&quot;,$(&quot;#photo&quot;)[0].files[0]);
    formData.append(&quot;service&quot;,'App.Passion.UploadFile');
    formData.append(&quot;token&quot;,token);
    $.ajax({
        url:'http://www.baidu.com/', /*接口域名地址*/
        type:'post',
        data: formData,
        contentType: false,
        processData: false,
        success:function(res){
            console.log(res.data);
            if(res.data[&quot;code&quot;]==&quot;succ&quot;){
                alert('成功');
            }else if(res.data[&quot;code&quot;]==&quot;err&quot;){
                alert('失败');
            }else{
                console.log(res);
            }
        }
    })
}
```
```
&lt;script&gt;
    $(function(){
	   $('.but').click(function(){
	      data = new FormData($('#form1')[0]); 
		  console.log(data);
		 // $.post('up.php',{p:2},function(data){
		 //    alert(data);
		//  })
		   $.ajax({  
            url: 'up.php',  
            type: 'POST',  
            data: data,  
            dataType: 'JSON',  
            cache: false,  
            processData: false,  //不处理发送的数据，因为data值是FormData对象，不需要对数据做处理 
            contentType: false   //不设置Content-type请求头
        }).done(function(ret){  
           console.log(ret);
        });  
	   })
	})
 &lt;/script&gt;
```