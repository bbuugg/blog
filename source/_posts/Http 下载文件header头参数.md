---
title: Http 下载文件header头参数
date: 2022-06-19 21:08:22
tags:
---

    header("Pragma: public");   //1
    header("Expires: 0"); //2
    header("Cache-Control:must-revalidate, post-check=0, pre-check=0");//3
    header("Content-Type:application/force-download");//4
    header("Content-Type:application/octet-stream");//5
    header("Content-Type:application/vnd.ms-excel;");//6
    header("Content-Type:application/download");//7
    header("Content-Disposition:attachment;filename=测试.xlsx");//8
    header("Content-Transfer-Encoding:binary");//9



1. Public指示响应可被任何缓存区缓存。

2. 浏览器不会响应缓存

3. must-revalidate ： 必须去服务器端验证，也就是一定不读缓存。

   Internet Explorer 5有一项叫作Lazy Update （“懒惰”更新）的新特性。Lazy Update可以使网站将一个对象缓存起来，同时又可以计算此对象的被点击数。这对广告图像、首页或搜索页是非常有用的。在这些页面上，你希望用户立即看到页面，但是你又想在某些地方更新内容并且跟踪记录有多少人已看过你的页面。对于一个Lazy Update页面，在它首次被访问时，其上的对象就被下载并被高速缓存起来。接下来，用户看到的是被缓存起来的内容。如果服务器有了新的内容，则该页面将会在后台被下载到高速缓存中。当用户下次访问该页面时，将显示被更新的内容。

   为了支持这种功能，Internet Explorer 5对于HTTP头信息使用两种新的时间间隔指示：pre-check 和post-check。pre-check扩展名定义了这样一段时间间隔（以秒记）：即在这段时间间隔之后，一个对象在显示给用户之前应被选中进行更新。选中对象也可以发生在该对象已经显示给用户之后，但是，要保证在用户下次想要看这个对象时，被高速缓存起来的副本是更新过的。post-check扩展名定义了这样一段时间间隔（以秒记）：即在这段时间之后，在显示给用户之前，该对象被选中进行更新。因为这两个扩展名是对HTTP头信息的扩充，所以，它们只能用于通过HTTP协议进行检索的页面上。另外，服务器必须产生HTTP 1.1响应。Internet Information Server (IIS) 4.0及其以后版本均支持这一特性。

   通过改变EXPIRES属性以及使用这两个控制高速缓存的扩展名，可以更快地与服务器连接并能更迅速地提交内容。Internet Explorer 5可以提高你的网站在用户的机器上的性能表现。另外，内容可以在后台被更新并在以后的访问中显示出来.

 

4. 请求该页面就出现下载保存窗口。

5. 二进制流，不知道下载文件类型。

6. 表示要下载的文件类型是 .xls   关于这个参数，可以去百度 ‘’ HTTP Content-type ‘’ 。http://www.cnblogs.com/benpaodelulu/p/7289860.html

7. 提示用户将当前文件保存到本地。

8. attachment --- 作为附件下载
   inline --- 在线打开
   作为附件下载，文件名是 测试.xlsx

9. Content-Transfer-Encoding: 参数
   "BASE64" / "QUOTED-PRINTABLE" /     
   "8BIT"   / "7BIT" / 
   "BINARY" / x-token
   8bit和binary都表示传输的内容是未编码的原始数据。
   但是根据邮件传输的相关协议，每行最多1000个字符。8bit表示数据符合这个协议要求，binary表示不一定符合（可能有超过1000字符的行）。
   BASE64 意味着身体是Base64编码ASCII，原本ISO-8859-1数据编码，并将该字符集在解码后再次设置（也就是说，本来是base64，解码以后再设置成base64编码）。
   说明文档： https://www.w3.org/Protocols/rfc1341/5_Content-Transfer-Encoding.html

   Cache-Control头域
       　　Cache-Control指定请求和响应遵循的缓存机制。在请求消息或响应消息中设置Cache-Control并不会修改另一个消息处理过程中的缓存处理过程。请求时的缓存指令包括no-cache、no-store、max-age、max-stale、min-fresh、only-if-cached，响应消息中的指令包括public、private、no-cache、no-store、no-transform、must-revalidate、proxy-revalidate、max-age。各个消息中的指令含义如下：
       　　Public指示响应可被任何缓存区缓存。
       　　Private指示对于单个用户的整个或部分响应消息，不能被共享缓存处理。这允许服务器仅仅描述当用户的部分响应消息，此响应消息对于其他用户的请求无效。
       　　no-cache指示请求或响应消息不能缓存
       　　no-store用于防止重要的信息被无意的发布。在请求消息中发送将使得请求和响应消息都不使用缓存。
       　　max-age指示客户机可以接收生存期不大于指定时间（以秒为单位）的响应。
       　　min-fresh指示客户机可以接收响应时间小于当前时间加上指定时间的响应。
       　　max-stale指示客户机可以接收超出超时期间的响应消息。如果指定max-stale消息的值，那么客户机可以接收超出超时期指定值之内的响应消息。



HTTP消息报头包括普通报头、请求报头、响应报头、实体报头。

    普通报头中的Cache-Control用于指定缓存指令，缓存指令是单向的（响应中出现的缓存指令在请求中未必会出现），且是独立的（一个消息的缓存指令不会影响另一个消息处理的缓存机制），HTTP1.0使用的类似的报头域为Pragma。
    请求时的缓存指令包括：no-cache（用于指示请示或响应消息不能缓存）、no-store、max-age、max-stale、min-fresh、only-if-cached；
    响应时的缓存指令包括：public、private、no-cache、no-store、no-transform、must-revalidate、proxy-revalidate、max-age、s-maxage。
    
    例：为了指示IE浏览器（客户端）不要缓存页面，服务器端如下：
    Header(“Cache-Control”, “no-cache”);
    Header(“Pragma”, “no-cache”);作用相当于上行代码，通常两者合用
    
    Expires实体报头域给出响应过期的日期和时间。为了让代理服务器或浏览器在一段时间以后更新缓存中（再次访问曾访问过的页面时，直接从缓存中加载，缩短响应时间和降低服务器负载）的页面，我们可以使用Expires实体报头域指定页面过期时间。例：Expires:Thu,15 Sep 2006 16:23:12 GMT
    HTTP1.1的客户端和缓存必须将其他非法的日期格式（包括0）看作已经过期。如：为了让浏览器不缓存页面，也可以利用Expires实体报头域，设置为0，

————————————————
版权声明：本文为CSDN博主「pendant59」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/benpaodelulu_guajian/article/details/77507140