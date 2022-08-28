---
title: 关于http响应和连接
date: 2020-08-15 07:13:57
tags:
---

# HTTP 响应头信息
&gt;HTTP请求头提供了关于请求，响应或者其他的发送实体的信息。

Allow	
服务器支持哪些请求方法（如GET、POST等）。

Content-Encoding	
文档的编码（Encode）方法。只有在解码之后才可以得到Content-Type头指定的内容类型。利用gzip压缩文档能够显著地减少HTML文档的下载时间。Java的GZIPOutputStream可以很方便地进行gzip压缩，但只有Unix上的Netscape和Windows上的IE 4、IE 5才支持它。因此，Servlet应该通过查看Accept-Encoding头（即request.getHeader(&quot;Accept-Encoding&quot;)）检查浏览器是否支持gzip，为支持gzip的浏览器返回经gzip压缩的HTML页面，为其他浏览器返回普通页面。

Content-Length	
表示内容长度。只有当浏览器使用持久HTTP连接时才需要这个数据。如果你想要利用持久连接的优势，可以把输出文档写入 ByteArrayOutputStream，完成后查看其大小，然后把该值放入Content-Length头，最后通过byteArrayStream.writeTo(response.getOutputStream()发送内容。

Content-Type	
表示后面的文档属于什么MIME类型。Servlet默认为text/plain，但通常需要显式地指定为text/html。由于经常要设置Content-Type，因此HttpServletResponse提供了一个专用的方法setContentType。

Date	
当前的GMT时间。你可以用setDateHeader来设置这个头以避免转换时间格式的麻烦。

Expires	
应该在什么时候认为文档已经过期，从而不再缓存它？

Last-Modified	
文档的最后改动时间。客户可以通过If-Modified-Since请求头提供一个日期，该请求将被视为一个条件GET，只有改动时间迟于指定时间的文档才会返回，否则返回一个304（Not Modified）状态。Last-Modified也可用setDateHeader方法来设置。

Location	
表示客户应当到哪里去提取文档。Location通常不是直接设置的，而是通过HttpServletResponse的sendRedirect方法，该方法同时设置状态代码为302。

Refresh	
表示浏览器应该在多少时间之后刷新文档，以秒计。除了刷新当前文档之外，你还可以通过setHeader(&quot;Refresh&quot;, &quot;5; URL=http://host/path&quot;)让浏览器读取指定的页面。
注意这种功能通常是通过设置HTML页面HEAD区的＜META HTTP-EQUIV=&quot;Refresh&quot; CONTENT=&quot;5;URL=http://host/path&quot;＞
实现，这是因为，自动刷新或重定向对于那些不能使用CGI或Servlet的HTML编写者十分重要。但是，对于Servlet来说，直接设置Refresh头更加方便。

注意Refresh的意义是&quot;N秒之后刷新本页面或访问指定页面&quot;，而不是&quot;每隔N秒刷新本页面或访问指定页面&quot;。因此，连续刷新要求每次都发送一个Refresh头，而发送204状态代码则可以阻止浏览器继续刷新，不管是使用Refresh头还是＜META HTTP-EQUIV=&quot;Refresh&quot; ...＞。

注意Refresh头不属于HTTP 1.1正式规范的一部分，而是一个扩展，但Netscape和IE都支持它。

Server	
服务器名字。Servlet一般不设置这个值，而是由Web服务器自己设置。

Set-Cookie	
设置和页面关联的Cookie。Servlet不应使用response.setHeader(&quot;Set-Cookie&quot;, ...)，而是应使用HttpServletResponse提供的专用方法addCookie。参见下文有关Cookie设置的讨论。

WWW-Authenticate	
客户应该在Authorization头中提供什么类型的授权信息？在包含401（Unauthorized）状态行的应答中这个头是必需的。例如，response.setHeader(&quot;WWW-Authenticate&quot;, &quot;BASIC realm=＼&quot;executives＼&quot;&quot;)。
注意Servlet一般不进行这方面的处理，而是让Web服务器的专门机制来控制受密码保护页面的访问（例如.htaccess）。

# HTTP持久连接
&gt;HTTP持久连接（HTTP persistent connection，也称作HTTP keep-alive或HTTP connection reuse）是使用同一个TCP连接来发送和接收多个HTTP请求/应答，而不是为每一个新的请求/应答打开新的连接的方法。

在 HTTP 1.0 中, 没有官方的 keepalive 的操作。通常是在现有协议上添加一个指数。如果浏览器支持 keep-alive，它会在请求的包头中添加：
1
Connection: Keep-Alive
然后当服务器收到请求，作出回应的时候，它也添加一个头在响应中：
1
Connection: Keep-Alive
这样做，连接就不会中断，而是保持连接。当客户端发送另一个请求时，它会使用同一个连接。这一直继续到客户端或服务器端认为会话已经结束，其中一方中断连接。
在 HTTP 1.1 中所有的连接默认都是持续连接，除非特殊声明不支持。HTTP 持久连接不使用独立的 keepalive 信息，而是仅仅允许多个请求使用单个连接。然而， Apache 2.0 httpd 的默认连接过期时间是仅仅15秒，对于 Apache 2.2 只有5秒。短的过期时间的优点是能够快速的传输多个web页组件，而不会绑定多个服务器进程或线程太长时间。
1. 较少的CPU和内存的使用（由于同时打开的连接的减少了）
2. 允许请求和应答的HTTP管线化
3. 降低拥塞控制（TCP连接减少了）
4. 减少了后续请求的延迟（无需再进行握手）
5. 报告错误无需关闭TCP连接

根据RFC 2616 （47页），用户客户端与任何服务器和代理服务器之间不应该维持超过2个链接。代理服务器应该最多使用2&times;N个持久连接到其他服务器或代理服务器，其中N是同时活跃的用户数。这个指引旨在提高HTTP响应时间并避免阻塞。

对于广泛普及的宽带连接来说，Keep-Alive也许并不像以前一样有用。web服务器会保持连接若干秒(Apache中默认15秒)，这与提高的性能相比也许会影响性能。
对于单个文件被不断请求的服务(例如图片存放网站)，Keep-Alive可能会极大的影响性能，因为它在文件被请求之后还保持了不必要的连接很长时间。 


# 关于HTTP的持久连接特性

HTTP协议是位于传输层之上的应用层协议，其网络层基础通常是TCP协议。TCP协议是面向连接和流的，因此连接的状态和控制对于HTTP协议而言相当重要。同时，HTTP是基于报文的，因此如何确定报文长度也是协议中比较重要的一点。
Persistent Connections持久连接
目的
在使用持久连接前，HTTP协议规定为获取每个URL资源都需要使用单独的一个TCP连接，这增加了HTTP服务端的负载，引起互联网拥塞。例如内嵌图片以及其他类似数据的使用要求一个客户端在很短时间内向同一个服务端发起多个请求。
使用持久连接的优点:
减少TCP连接数量
在一个连接上实现HTTP请求和应答的流水，即允许客户端发出多个请求，而不必在接收到前一请求的应答后才发出下一请求，极大减少时间消耗
后续请求延迟减少，无需再在TCP握手上耗时
可以更加优雅地实现HTTP协议，由于持续连接的存在无需报告错误后无需关闭连接，因此客户端可使用最新的协议特性发出请求，如果接收到表示错误的应答，则换用更旧的语义。

总体描述
HTTP/1.1和之前版本的显著区别是HTTP/1.1默认使用持久连接。即，除非服务端在应答中明确指出，客户端应当假定服务端会维持一个持久连接，即使从服务端收到的应答是报告错误。
持久连接对关闭TCP连接的行为提供信号量机制支持。这个信号量是在HTTP头中的Connection域设置，注意Client向Proxy发出请求时该域可能被Proxy-Connection域替换。一旦close信号被表明，客户端绝不能再通过该连接发送更多的请求。

协商(Negotiation)
HTTP/1.1 服务端可以假定HTTP/1.1客户端会维持持久连接，除非请求中Connection域的值是&quot;close&quot;.同样的，如果服务端打算在送出应答后立即关闭连接，它应当在应答中包含同样的Connection域。(TCP连接关闭是双向的,此时TCP进入半关闭状态)
同样的，HTTP/1.1客户端可以期望连接是持久的，除非如前所述收到表示连接关闭的应答。当然，也可以主动发出一个包含Connection:close的请求以表明终止连接。
无论客户端还是服务端发出的报文包含Connection:close，则该请求均为连接上的最后一个请求(服务端发出此应答后关闭，因此不可能接收更多的请求)
报文传输长度
为保证持久性，连接上的报文都必须有一个自定义的报文传输长度(否则必须通过连接的关闭表示报文结束，因为TCP连接是面向流的)，确定的规则按优先级由高到低排列如下：
报文传输长度指报文中出现的报文体的长度(即，不包括头长度，因为报文头的结束可通过连续两个CRLF确定）
1.任何绝不能包含报文体(如1xx,204,304)的应答消息总是以头域后的第一个空行结束,无视头中所有的entity类型域的设置，包括Content-Length域。
2.Transfer-Encoding域出现，其值为除&quot;identify&quot;以外的其他值，则用&quot;chunked&quot;传输编码方式确定传输长度，具体方式留待下篇分析。
3.Content -Length域出现，且Transfer-Encoding域未出现(出现则忽略Content-Length域)。Content-Length域的值为十进制数的字节序，如Content-Length：1234，则1、2、3、4是分别作为一个octet传输的，因此需要atoi转换成数值。
4.如果报文使用了&quot;multipart/byteranges&quot;的媒体类型，且没对传输长度做前面的指明，则这种自分割的媒体类型定义了传输长度。具体参见Range头域的说明。
5.服务端关闭连接(此方法不可用于客户端发出的请求报文，因为客户端关闭连接则使得服务端无法发送应答).
为保持和HTTP/1.0的兼容性, 包含报文体的HTTP/1.1请求必须包含合法的Content-Length头域,除非明确知道服务端是HTTP/1.1兼容的.如果请求包含消息体, 而没有Content-Length域,那么如果服务端无法确定消息长度时,它会返回400(无效请求),或者坚持获取合法Content-Length 而返回411(要求包含长度).

所有接收实体的HTTP/1.1应用程序必须接受&quot;chunked&quot;传输编码, 这样允许当报文长度无法预先确定时可以运用此机制获取报文长度.
报文不能同时包含Content-Length头域和非&quot;identity&quot; Transfer-Encoding.如果出现了, Content-Length域必须被忽略.
当Content-Length域在允许报文体的报文中存在时, 其域值必须严格等于消息体中的8比特字节.HTTP/1.1 user agent 必须在接收并检测到一个错误的长度时提醒用户.
以上方法中，最常见的还是使用Content-Length域表示报文体长度，Transfer-Encoding需要按格式解码才能还原出发送编码前的报文。

流水
支持持久连接的客户端可以流水发送请求，服务端必须按发送的顺序发送应答。
假定持久连接和连接后即可流水的客户端应当做好在第一次流水失败后重新尝试此连接。在这样的尝试中，在确定连接是持久的之前，客户端不能再流水。
客户端同样必须准备好在服务端送回所有相关应答前就关闭连接时重发请求。
不应流水non-idempotent方法

Proxy Servers
对于代理服务端而言，正确实现Connection头域指定的属性尤为重要。
代理服务端必须分立通告它的客户端和连接的原始服务端持久连接的属性，每个持久连接设置仅针对一个传输连接。

实践考量
超时值，服务端通常会为每个连接维护一个定时器，一旦某个连接不活跃超过一定时间值，服务端会关闭此连接。考虑到一个客户端可能通过代理服务端发出更多连接，代理服务端通常会将超时值设置得更高。
还有一些关于从异步关闭中恢复的讨论。

报文传输要求
使用TCP流控制来解决服务端临时负载过高问题，而不是简单的依赖客户端重连而关闭连接。
监视连接情况以获取错误状态消息
关于使用100(继续)状态码
100状态码用于客户端发送请求体之前测试是否可以发送该请求，对于Proxy，有以下要求：
1.如果代理服务端接收到包含Expect头域值为&quot;100-continue&quot;的请求, 而不明确知道下一跳服务不支持HTTP/1.1以上版本, 则它必须转发这个请求, 包括Expect头域.
2.如果代理知道下一跳服务端为HTTP/1.0或者更低版本, 则它不能转发此请求, 且必须以407应答客户端.
3.如果明确知道发出请求的客户端版本为HTTP/1.0或者更低，则代理服务端绝不能转发100应答,这条规则凌驾于转发1xx应答的一般准则.

Connection头域说明
BNF文法：
Connection = &quot;Connection&quot; &quot;:&quot; 1#(connection-token)
connection-token = token
Connection头域中的token用于指定对于特定连接有意义的选项，因此proxy在转发前要扫描此域，从头中去除和token同名的域。例如Connection:Range,则要去掉Range域。
HTTP/1.1定义了close这个token，发送者用此token表示在完成这个报文所属请求/应答的收发后连接将关闭。

## HTTP的持久连接对Web服务性能的影响

我们的 Web 页面通常有很多对像(Object)组成。如：jss 样式表、图片、scripts、文档等。所以用户浏览一个网页文件时候，要向 Web 服务器发送多次请求(要从服务器上获取一个Object就要向服务器发送一个请求)，浏览器根据 jss 样式表把从服务器获取的这些html页面对象合成一个完整的html页面展示给用户。
        最早我们的浏览器是单线程的，意味着一次只能向浏览器发送一个Object请求，等到该Object传输完成了，再向服务发送第二个Object的请求。我们把它称为串行事务处理。串行事务处理，使得我们的连接时延会叠加，用户的体验效果差。如，页面有多幅图片，页面正在加载一幅图片时，页面上其它地方都没有动静，也会让人门觉得很慢。后来出现了多线程的浏览器，当用户点击打开一个页面时，会同时向服务器同时发起多个用户请求(也就是并行处理方式)，减少了连接时延叠加，同时加速了一个web页面对象的加载速度，让用户有更好的体验效果。
        虽然采用多线程的浏览器加速了页面的加载速度，但是如果我们只对连接进行简单的管理(如不使用 keep alive)，浏览器每获得一个Web对像都要使用一个新的TCP连接。
意思是说我们加载的html页面有多少个页面对象，浏览器与服务器要建立多少条TCP连接。大家都知道使用TCP传输数据之前，要先经过三次握手，三次握手成功以后，双方才能够进行数据的传输。
所以说，我们使用TCP/IP进行数据网络传输必定会造成延迟的。双方完成数据的传输以后还要经过TCP的四次断开的过程。一个TCP的连接要经过：建立连接 、传输数据、拆除连接。

        TCP的建立连接和拆除连接是很费时的，有时候甚至比数据传输的时间还长。所以，虽然浏览器采用了并发处理方式，加速了页面的加载速度。但是请求一个页面对像就需要与服务器建立一条TCP连接。如果用户浏览的页面文件有1000个object的话，从服务器请求数据到展示给用户，

        最基本延迟时间 = 1000*(平均每个TCP连接建立时间 + 平均每个TCP连接拆除时间)。
随着我们的页面对像的增加，这个延迟时间是不断增长的。客户端每请求一个object，就要与服务器建立一条TCP连接，服务器每维护一条TCP连接是要消耗一定的资源(如内存)。所以，也加速了服务器的负担。对服务器的并发用户数也造成很大影响。所以后来 HTTP/1.1 使用了重用TCP连接功能来消除连接及关闭时延。允许HTTP设备在事务处理结束之后将TCP连接保持在打开状态，
以便为后续的HTTP请求重用现存的TCP连接。在事务处理结束之后仍然保持在打开状态的TCP连接被称为持久连接。也称为 TCP 重用。


      是如何重用TCP连接的呢？
      假如，浏览的网页文件有400个object.我们的浏览器是4线程的，浏览器会并行向 Web 服务器发送4个 TCP连接请求。当这4个TCP请求与服务器建立连接完成数据传输以后，并不是
把它拆除掉。浏览器与web服务器协定使用 keep-alive 功能时。HTTP设备就会在事务处理结束之后将该4条TCP连接保持在打开状态。浏览器就使用这4条TCP连接完成后续的396个object的数据转输。
        持久连接降低了时延和连接建立的开销，将连接保持在已调谐状态，而且减少了打开连接的潜在数量。但是，管理 持久连接时要特别小心，不然就会累积出大量的空闲连接，耗费客户端和服务器上的资源。下面是 Apache web 服务器管理持久连接的一些配置：

[root@node2 ~]# vim /etc/httpd/extra/httpd-default.conf
...
#KeepAlive On
KeepAlive On
#
# MaxKeepAliveRequests: The maximum number of requests to allow
# during a persistent connection. Set to 0 to allow an unlimited amount.
# We recommend you leave this number high, for maximum performance.
# 保持连接允许传输的最大请求数
MaxKeepAliveRequests 100
# KeepAliveTimeout: Number of seconds to wait for the next request from the
# same client on the same connection.
# 在同一个客户端的连接，等待下一个请求的超时时间
KeepAliveTimeout 5
...
说明：

这些就是 Keep-Alive选项。
注意，Keep-Alive 首部只是请求将连接保持在活跃状态。发出 keep-alive 请求之后，客户端和服务器并不一定会同意进行 keep-alive 会话。
它们可以在任意时刻关半空闲的 keep-alive 连接，并可随意限制 keep-alive 连接所处理事务的数量。

下面来看看，客户端与服务器怎样商量它们是否使用HTTP协议的持久连接功能的呢？
实现 HTTP/1.0 keep-alive 连接的客户端可以通过包含 Connection: Keep-Alive 首部请求将一条连接保持在打开状态。


通过 Google Chrome 浏览器的开发者工具来查看，访问 http://192.168.203.99/index.html 的请求头信息。

Request Header
Accept:text/html,application/xhtml+xml,application/xml;q=0.9,p_w_picpath/webp,*/*;q=0.8
Accept-Encoding:gzip,deflate,sdch
Accept-Language:zh-CN,zh;q=0.8
Cache-Control:no-cache
Connection:keep-alive     -----&gt; 请求将一条连接保持在打开状态。
Cookie:2c407_ol_offset=97; 2c407_ipstate=1402781651; 2c407_jobpop=0; 2c407_winduser=BD4OUFQKBQkLVgReBgsAAFsDVlMKB1MGUQ4LAwcFUlgBBms; 2c407_ck_info=%2F%09; 2c407_lastpos=index; 2c407_lastvisit=49%091402713397%09%2Findex.php
Host:192.168.203.99
Pragma:no-cache
User-Agent:Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.137 Safari/537.36
通过工具 crul 获得的响应头信息。

[root@node2 ~]# curl -I http://192.168.203.99/index.html
HTTP/1.1 200 OK
Server: nginx/1.0.11
Date: Sat, 14 Jun 2014 09:17:15 GMT
Content-Type: text/html
Content-Length: 151
Last-Modified: Thu, 01 May 2014 04:21:03 GMT
Connection: keep-alive
Accept-Ranges: bytes
说明：
    如果服务器愿意为下一条请求将连接保持在打开状态(意思是说下一次请求数据时，可以通过该TCP连接传输数据，不需要建立新的TCP连接了)，
    就在响应中包含相同的首部 Connection: keep-alive。
    如果响应中没有 Connection: keep-alive 首部，客户端就认为服务器不支持 keep-alive,会在发回响应报文之后关闭连接@。
    从上在请求首部和响应首部分析，我们使用了HTTP 持久连接的功能。

总结：
   Keep-Alive 连接的限制和规则：
   1、在 HTTP/1.0 中，keep-alive 并不是默认使用的，客户端必须发送一个 Connection: Keep-Alive

         请求首部来激活 keep-alive 连接。
   2、Connection: Keep-Alive 首部必须随所有希望保持持久连接的报文一起发送。如果客户端没有发

         送 Connection: Keep-Alive 首部，服务器就会在那条请求之后关闭连接。
   3、客户端探明响应中没有 Connection: Keep-Alive 响应首部，就可以知道服务器发出响应之后是否

          会关闭连接了。
   4、为了避免出现大量的空闲的TCP连接，要定义持久连接的超时时间 timeout.  限制操持连接的TCP

         连接最多能完成多少个事务 MaxKeepAliveRequests

转载于:https://blog.51cto.com/9528du/1426695