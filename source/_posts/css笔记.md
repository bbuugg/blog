---
title: css笔记
date: 2020-08-13 09:31:33
tags:
---

#文本换行
**word-wrap:**

css的 word-wrap 属性用来标明是否允许浏览器在单词内进行断句，这是为了防止当一个字符串太长而找不到它的自然断句点时产生溢出现象。

<!-- more -->

**word-break:**

css的 word-break 属性用来标明怎么样进行单词内的断句。

white-space:bread-spaces;
# 文本格式 
&gt;text-decoration : none || underline || blink || overline || line-through 
- text-decoration:none 无装饰，通常对html下划线标签去掉下划线样式
- text-decoration:underline 下划线样式
- text-decoration:line-through 删除线样式-贯穿线样式
- text-decoration:overline 上划线样式

### css的font-style  属性
- `normal `: 正常的字体(默认字体样式，可用于去掉html i斜体标签默认斜体样式)
- `italic` : 斜体。对于没有斜体变量的特殊字体，将应用oblique
- `oblique` : 倾斜的字体

## initial
initial 关键字用于设置 CSS 属性为它的默认值。可用于任何 HTML 元素上的任何 CSS 属性。设置 `&lt;div&gt;` 元素内的文本颜色为红色，但是为 `&lt;h1&gt;` 元素保持最初的颜色：
```
div {color: red; }
h1 {color: initial; }
```

## 文本删除线和颜色线体
text-decoration:line-through red solid;

# 块级元素使用float属性

块级元素使用float属性后，将其属性变成inline-block，不能改变其块级元素的性质，只是能有块级元素的特性，不独占一行，宽度不会占满父元素，和行内元素排列成一行

行内元素使用float属性后，也是将其属性变成inline-block，可以设置宽高，padding，margin属性

# 模糊

https://developer.mozilla.org/zh-CN/docs/Web/CSS/backdrop-filter
```
backdrop-filter: saturate(180%) blur(20px);  
```

# zoom属性的作用

这里介绍一下CSS中的Zoom属性，这个属性一般不为人知，甚至有些CSS手册中都查询不到。但经常会在一些css样式中看到它出现。

Zoom属性是IE浏览器的专有属性，Firefox等浏览器不支持。它可以设置或检索对象的缩放比例。除此之外，它还有其他一些小作用，比如触发ie的hasLayout属性，清除浮动、清除margin的重叠等。

zoom版本：IE5.5+专有属性　继承性：无

语法：

zoom : normal | number 

参数：

normal : 　使用对象的实际尺寸
number : 　百分数|无符号浮点实数。浮点实数值为1.0或百分数为100%时相当于此属性的normal值

说明：

CSS中zoom:1的作用
兼容IE6、IE7、IE8浏览器，经常会遇到一些问题，可以使用zoom:1来解决，有如下作用：
触发IE浏览器的haslayout
解决ie下的浮动，margin重叠等一些问题。
比如，使用DIV做一行两列显示，

HTML代码：
```html
<div class="h_mainbox"> 
	<h2>推荐文章</h2> 
	<ul class="mainlist"> 
		<li><a href="#" style="color:#0000FF" target="_blank">测试一</a></li> 
		<li><a href="#" style="color:#0000FF" target="_blank">测试二< /a></li> 
	</ul> 
</div>
```
CSS代码：
```css
    .h_mainbox {
		border:1px solid #dadada; 
		padding:4px 15px; 
		background:url(../mainbox_bg.gif) 0 1px repeat-x;
		margin-bottom:6px; overflow:hidden
	}
	.h_mainbox h2 { 
		font-size:12px; 
		height:30px; 
		line-height:30px; 
		border-bottom:1px solid #ccc; 
		color:#555;
	} 
    .h_mainbox h2 span { 
		float:right; 
		font-weight:normal;
	} 
    .h_mainbox ul { 
		padding:6px 0px; 
		background:#fff;
		} 
    .mainlist { 
		overflow:auto; zoom:1;
	} 
    .h_mainbox li { 
		width:268px; 
		float:left; 
		height:24px; 
		overflow:hidden; 
		background:url(../icon3.gif) 0 6px no-repeat; 
		padding:0px 5px 0px 18px; 
		line-height:200%;
	}
```
.mainlist样式名字那里就可以在IE6、IE7、IE8正常显示效果了。

css中的zoom的作用

1、检查页面的标签是否闭合
不要小看这条，也许折腾了你两天都没有解决的 CSS BUG 问题，却仅仅源于这里。毕竟页面的模板一般都是由开发来嵌套的，而他们很容易犯此类问题。
快捷提示：可以用 Dreamweaver 打开文件检查，一般没有闭合的标签，会黄色背景高亮。

2、样式排除法
有些复杂的页面也许加载了 N 个外链 CSS 文件，那么逐个删除 CSS 文件，找到 BUG 触发的具体 CSS 文件，缩小锁定的范围。对于刚才锁定的问题 CSS 样式文件，逐行删除具体的样式定义，定位到具体的触发样式定义，甚至是具体的触发样式属性。

3、模块确认法
有时候我们也可以从页面的 HTML 元素出发。删除页面中不同的 HTML 模块，寻找到触发问题的 HTML 模块。

4、检查是否清除浮动
其实有不少的 CSS BUG 问题是因为没有清除浮动造成的。养成良好的清除浮动的习惯是必要的，推荐使用 无额外 HTML 标签的清除浮动的方法（尽量避免使用 overflow:hidden;zoom:1 的类似方法来清除浮动，会有太多的限制性）。

5、检查 IE 下是否触发 haslayout
很多的 IE 下复杂 CSS BUG 都与 IE 特有的 haslayout 息息相关。熟悉和理解 haslayout 对于处理复杂的 CSS BUG 会事半功倍。推荐阅读 old9 翻译的 《On having layout》（如果无法翻越穿越伟大的 GFW，可阅读 蓝色上的转帖 ）
快捷提示：如果触发了 haslayout，IE 的调试工具 IE Developer Toolbar 中的属性中将会显示 haslayout 值为 -1。

6、边框背景调试法
故名思议就是给元素设置显眼的边框或者背景（一般黑色或红色），进行调试。此方法是最常用的调试 CSS BUG 的方法之一，对于复杂 BUG 依旧适用。经济实惠还环保^^。最后想强调一点的是，养成良好的书写习惯，减少额外标签，尽量语义，符合标准，其实可以为我们减少很多额外的复杂 CSS BUG，更多的时候其实是我们自己给自己制造了麻烦。希望你远离 BUG ，生活越来越美好。


https://www.cnblogs.com/besthcp/p/4062950.html