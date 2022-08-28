---
title: jQuery选择器获取第一个子元素以及带空格的class
date: 2020-08-12 17:59:18
tags:
---

jQuery选择器选取第一个子元素
`$(&quot;p:first&quot;)`

jQuery选择器选取HTML 中 class=&quot;hov_bg hov2&quot; class中带有空格的这类元素

$(&quot;.hov_bg.hov2&quot;);
该选择器可以筛选出同时拥有class=&quot;hov_bg hov2&quot;样式的HTML元素

$(&quot;.hov2&quot;);
该选择器可以筛选出class=&quot;hov2&quot;和class=&quot;hov_bg hov2&quot;的元素

例子:

```html
&lt;div class=&quot;container&quot;&gt;simple&lt;/div&gt;
&lt;div class=&quot;layer container&quot;&gt;complex&lt;/div&gt;
&lt;script type=&quot;text/javascript&quot;&gt;
alert($(&quot;.container.layer&quot;).html());
&lt;/script&gt;
```
class中带空格不是指一个class，而是指两种class中的任意一种。
下面是详解：

CSS 多类选择器
在上一节中，我们处理了 class 值中包含一个词的情况。在 HTML 中，一个 class 值中可能包含一个词列表，各个词之间用空格分隔。例如，如果希望将一个特定的元素同时标记为重要（important）和警告（warning），就可以写作：
&lt;p class=&quot;important warning&quot;&gt; This paragraph is a very important warning. &lt;/p&gt;
这两个词的顺序无关紧要，写成 warning important 也可以。
我们假设 class 为 important 的所有元素都是粗体，而 class 为 warning 的所有元素为斜体，class 中同时包含 important 和 warning 的所有元素还有一个银色的背景 。就可以写作：


    .important {[font-weight](https://www.baidu.com/s?wd=font-weight&amp;tn=SE_PcZhidaonwhc_ngpagmjz&amp;rsv_dl=gh_pc_zhidao):bold;}
    .warning {[font-weight](https://www.baidu.com/s?wd=font-weight&amp;tn=SE_PcZhidaonwhc_ngpagmjz&amp;rsv_dl=gh_pc_zhidao):italic;}
    .important.warning {background:silver;}