---
title: ubuntu 安装ImageMagic
date: 2021-08-29 13:36:49
tags:
---

I. 安装ImageMagic

1. 安装：

sudo  apt-get install imagemagick

2. 测试:
1). 版本察看
简单地执行:
引用
convert -version

如果看到下面的信息说明安装已经成功
引用
Version: ImageMagick 6.4.3 2008-08-27 Q16 OpenMP http://www.imagemagick.org
Copyright: Copyright (C) 1999-2008 ImageMagick Studio LLC


2). 压缩图片.
当前目录下有一个文件名字叫hill.png,执行
引用
convert -sample 25%x25% hill.png  hill_t.png

将缩小hill.png为原来的25%，生成新的文件名叫hill_t.png

如果出现如下错误提示:
引用
convert: error while loading shared libraries: libMagickCore.so.1: cannot open shared object file: No such file or directory


将so所在的路径加入到LD_LIBRARY_PATH(前面的安装方式默认安装so到/usr/local/lib目录下)
引用
  export LD_LIBRARY_PATH=/usr/local/lib


当执行jpg图片缩放的时候,
3). 压缩jpg图片
引用
convert -sample 25%x25% water.png  water_t.png

系统提示:
引用
convert: no decode delegate for this image format `water.jpg&#039;.
convert: missing an image filename `t_water.jpg&#039;.


其他：

ImageMagick是一个免费的创建、编辑、合成图片的软件。

原文地址：https://blog.csdn.net/jacke121/article/details/76126245