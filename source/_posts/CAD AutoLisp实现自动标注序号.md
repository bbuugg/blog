---
title: CAD AutoLisp实现自动标注序号
date: 2020-07-05 11:34:07
tags:
---

&gt;autolisp插件，加载后，使用方法如下：

autolisp代码如下，复制到记事本，以【.lsp】为后缀命名，打开cad，输入【appload】加载，命令【TES】（可以自己修改命令）。在使用过程中可以添加创建图层命令将所有数字放到同一个图层中便于修改，由于某些图纸坐标有修改，所以使用前需要恢复坐标或者将恢复坐标命令添加到下面代码中自动执行。
```shell
(defun c:tes ( / #n5 &amp;p1 tr1)
(if (null #n1) (setq #n1 1) )
(if (setq tr1 (getint (strcat \&quot;\\请输入整数值:&lt;\&quot; (rtos #n1 2 0) \&quot;&gt;\&quot;)))
(setq #n1 tr1)
(setq tr1 #n1)
)
(if (null #n2) (setq #n2 100) )
(initget 6)
(if (setq #n5 (getdist (strcat \&quot;\\n请输入文字高度:&lt;\&quot; (rtos #n2) \&quot;&gt;\&quot;)))
(setq #n2 #n5)
(setq #n5 #n2)
)
(while (setq &amp;p1 (getpoint \&quot;\\n请选择插入点\&quot;))
(entmake (list \'(0 . \&quot;text\&quot;) (cons 10 &amp;p1) (cons 1 (rtos tr1 2 0)) (cons 40 #n5) \'(41 . 0.5) \'(72 . 4) (cons 11 &amp;p1)))
(entmake (list \'(0 . \&quot;circle\&quot;) (cons 10 &amp;p1) (cons 40 (* #n5 0.85))))
(setq tr1 (1+ tr1))
(setq #n1 tr1)
)
(princ)
)
```