---
title: css笔记
date: 2020-08-13 09:31:33
tags:
---

#文本换行
**word-wrap:**

css的 word-wrap 属性用来标明是否允许浏览器在单词内进行断句，这是为了防止当一个字符串太长而找不到它的自然断句点时产生溢出现象。

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