---
title: Css笔记
toc: true
date: 2022-11-05 13:49:38
tags:
---

# before / after

例如下面的代码，content可以是目标元素的任何属性，只需要使用attr即可

```html
<a class="email" title="redirect">URL</a>
```

```css
.email::before {
    content: ""
}
```

```css
.email::after {
    content: attr(title)
}
```

# backdrop-filter

backdrop-filter CSS 属性可以让你为一个元素后面区域添加图形效果（如模糊或颜色偏移）。因为它适用于元素背后的所有元素，为了看到效果，必须使元素或其背景至少部分透明。

https://developer.mozilla.org/zh-CN/docs/Web/CSS/backdrop-filter
