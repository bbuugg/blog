---
title: Js获取图片宽高
date: 2022-05-15 17:16:19
tags:
---

```
<img id="do" src="./Web/img/20211207_20145862_avatar.png.jpg" alt="" />
<script>
	setTimeout(() => {
	let i = document.getElementById("do");
	console.log(i.clientWidth);
	}, 1000);
</script>
```