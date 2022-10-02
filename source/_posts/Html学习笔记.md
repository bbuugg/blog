---
title: Html学习笔记
date: 2020-07-05 11:34:07
cover: https://tse1-mm.cn.bing.net/th/id/OIP-C.xNRYPjKNWnKkh46rM7B5iAHaEK?pid=ImgDet&rs=1
tags:
---

## li标签居中
把要居中的li设置成 display: inline-block;
然后在li加上 text-align: center; 让li居中。
## img标签属性
alt属性是当图片无法正常加载时显示的提示文字，而在ie中会被作为鼠标指向的文字提示。更好兼容的的鼠标指向文字提示应该使用title属性。
## 块级元素或者行内元素在设置float属性之后是否改变元素的性质？
块级元素使用float属性后，将其属性变成inline-block，不能改变其块级元素的性质，只是能有块级元素的特性，不独占一行，宽度不会占满父元素，和行内元素排列成一行
行内元素使用float属性后，也是将其属性变成inline-block，可以设置宽高，padding，margin属性


## 行内元素可不可以包含块元素，即行内元素是父元素。？？

块级元素会独占一行,默认情况下,其宽度自动填满其父元素宽度. 

行内元素不会独占一行,相邻的行内元素会排列在同一行里,直到一行排不下,才会换行,其宽度随元素的内容而变化.  　

块级元素可以设置width,height属性.  　　

行内元素设置width,height属性无效.  　　

块级元素即使设置了宽度,仍然是独占一行.  　　  　　

块级元素可以设置margin和padding属性.  　　

行内元素的margin和padding属性,水平方向的padding-left,padding-right,margin-left,margin-right都产生边距

效果,但竖直方向的padding-top,padding-bottom,margin-top,margin-bottom却不会产生边距效果.  　　  　　

块级元素对应于display:block.  　　

行内元素对应于display:inline. 　　

### display:none与visible:hidden的区别
display:none和visible:hidden都能把网页上某个元素隐藏起来，但两者有区别:

display:none ---不为被隐藏的对象保留其物理空间，即该对象在页面上彻底消失，通俗来说就是看不见也摸不到。

visible:hidden--- 使对象在网页上不可见，但该对象在网页上所占的空间没有改变，通俗来说就是看不见但摸得到。

> 设置一个div居中，使用padding:0 auto;width:1000px;
但是结果是不能使得元素居中
使用margin：0 auto；的话，居中的两边背景色会用空白。

解决办法：

把要居中的div 设置成 display: inline-block;，然后在父div加上 text-align: center; 让div居中。

## 关于行内元素和块元素
1、html中行内元素bai(a)中能不能放块元素（div）
回答du：不能。
XHTML标准是这样zhi定义的：
*inline
*a
*inline excluding an enclosed a element
解释就是 a标签属于daoinline， a标签只能嵌套inline元素，并也不能再嵌套a标签。
2、那span里面能不能放div呢？？
回答：不能
1、html中行内元素(a)中能不能放块元素（div）
回答：不能。
XHTML标准是这样定义的：
*inline
*span
*inline
解释就是 span是属于inline，并且span也只能嵌套inline
另外，XHTML标准还有一些我们容易疏漏的，比如所有标签都要小写，例如<html>等
我个人理解就是标准毕竟只是标准，就好像大家都走路靠右边走，但是你如果非要靠左边走，也没人拦你。所以写的时候有可能会通过浏览器的认证，但是如果在某些严格符合xhtml规范的编译器或浏览器，他们就不认账了。
所以按照xhtml规范可以培养自己良好的开发习惯。
顺便提一下，html元素分3中，顶级元素、块级元素、内联元素。
行内实际上就是内敛元素...

```
html access-charset
```
# img 的alt属性
alt属性是当图片无法正常加载时显示的提示文字，而在ie中会被作为鼠标指向的文字提示。更好兼容的的鼠标指向文字提示应该使用title属性。