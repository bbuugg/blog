---
title: ll 命令排序详解
date: 2021-05-16 21:54:36
tags:
---

```
ll  默认按照文件名字母顺序排序，A在最前
ll -SX  按照文件类型排序，扩展名首字母排序，文件夹最前
ll -St  按照创建时间排序，最近的最前
ll -SS  按照大小排序，最大的最前
```

选项
```
-S按文件大小排序
      --sort = WORD按WORD而不是名称排序：无（-U），大小（-S），
	  		时间（-t），版本（-v），扩展名（-X）
      --time =带有-l的WORD，将时间显示为WORD而不是默认值
			  修改时间：一次或访问或使用（-u）
			  ctime或状态（-c）；也使用指定的时间
			  作为排序键，如果--sort = time
      --time-style =带有-l的样式，使用样式STYLE显示时间：
			  全ISO，长ISO，ISO，区域设置或+ FORMAT;
			  FORMAT的解释方式类似于'date'；如果格式
			  是FORMAT1 <newline> FORMAT2，则FORMAT1适用
			  非最新文件，FORMAT2到最近文件；
			  如果STYLE带有'posix-'前缀，则为STYLE
			  仅在POSIX语言环境外生效
  -t按修改时间排序，最新的优先
```