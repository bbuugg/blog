---
title: git commit 使用及规范
date: 2022-04-26 19:03:31
cover: https://tse1-mm.cn.bing.net/th/id/R-C.c81d89b85dae3966a7f951931c2134c9?rik=AI7Qvu8Vx388qg&riu=http%3a%2f%2fwww.artit-k.com%2fwp-content%2fuploads%2f2017%2f09%2fGit-Workshop.png&ehk=hvkGU9i169m0Qglqt%2fbkNg7vEGCGZE23ByZLTjRN6%2f8%3d&risl=&pid=ImgRaw&r=0
tags:
---

## git commit 使用说明

### 1 概述

git提交推荐使用命令行工具，请严格遵循提交格式。

<!-- more -->

### 2 提交格式

在您`git add`后，推荐执行`git commit`进行提交，如无特殊描述信息要添加，也可以`git commit -m <mess>`进行提交。

要求提交格式如下：

```xml
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

type表示提交类别，scope表示修改范围，subject表示标题行， body表示主体描述内容。

#### 2.1 type说明

type在commit的是否必须存在。

- feat: 添加新特性
- fix: 修复bug
- docs: 仅仅修改了文档
- style: 仅仅修改了空格、格式缩进、逗号等等，不改变代码逻辑
- refactor: 代码重构，没有加新功能或者修复bug
- perf: 优化相关，比如提升性能、体验
- test: 增加测试用例
- chore: 改变构建流程、或者增加依赖库、工具等
- revert: 回滚到上一个版本

#### 2.2 scope说明

非必填（建议填写），scope用于说明 commit 影响的范围，建议填写影响的功能模块。

如果你的修改影响了不止一个`scope`，你可以使用`*`代替。

#### 2.3 subject说明

必填， commit 目的的简短描述，不超过50个字符。

- 以动词开头，使用第一人称现在时，比如`change`，而不是`changed`或`changes`
- 第一个字母小写
- 结尾不加句号

#### 2.4 body说明

非必填（建议填写），可描述当前修改的行为详细信息或修改的目的。

#### 2.5 footer说明

非必填，一般用于描述BREAKING CHANGE，在项目开发中一般不需要填写，组件研发的工程需要填写。

格式：以`BREAKING CHANGE`开头，后面是对变动的描述、以及变动理由和迁移方法。

### 3 提交方式

如上2所示格式，本质上是改变文件 <u>*.git/COMMIT_EDITMSG*</u> 中的文本，实际提交过程如下（推荐命令行提交）：

#### 3.2 cmd（notepad）

window系统下默认git编辑工具是vim，如无相关基础，建议使用window默认的文本编辑器（这里不赘述vim相关编辑方法）。

修改git默认文本编辑器： `git config core.editor notepad`

修改后执行`git commit`,会弹出文本编辑器。

我们要按照规定的格式在注释前加入要提交的commit信息：

```undefined
feat(人员新增): 增加人员批量导入

- 增加批量报盘功能
- 增加人员报盘后结果查询功能
- 修改人员新增布局
```

然后保存并关闭，会提示如下信息：

> [master 756c07e] feat(人员新增): 增加人员批量导入
>  1 file changed, 2 insertions(+)

在push完成后，gitlab的commit列表中会有如下信息：

![img](https:////upload-images.jianshu.io/upload_images/16146226-56531e99792ad355.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

commit.png

#### 3.2 shell（GNU nano）提交方式

在您执行`git commit`后，命令行会有如下显示：

> ```
> projectRoot/.git/COMMIT_EDITMSG
> ```
>
> \# 请为您的变更输入提交说明。以 '#' 开始的行将被忽略，而一个空的提交
>  \# 说明将会终止提交。
>  \#
>  \# 位于分支 master
>  \# 您的分支与上游分支 'origin/master' 一致。
>  \#
>  \# 要提交的变更：
>  \#       修改：     CHANGELOG.md
>  \#
>  \# 未跟踪的文件:
>  \#       .idea/
>  \#
>
> 
>
> ```json
>                             [ 已读取 13 行 ]
> ```
>
> ^G 求助      ^O 写入      ^W 搜索      ^K 剪切文字  ^J 对齐      ^C 游标位置
>  ^X 离开      ^R 读档      ^\ 替换      ^U 还原剪切  ^T 拼写检查  ^_ 跳行

如上所示，我们要按照规定的格式在注释前加入要提交的commit信息：

```undefined
feat(人员新增): 增加人员批量导入

- 增加批量报盘功能
- 增加人员报盘后结果查询功能
- 修改人员新增布局
```

输入完成后，根据快捷键提示，按`ctrl + O`，然后出现要修改的MSG文件名，按回车键。此时提示如下：

> [ 已写入 19 行 ]

最后按`ctrl + X`提交完成，提示如下：

> [master 756c07e] feat(人员新增): 增加人员批量导入
>  1 file changed, 2 insertions(+)

在push完成后，gitlab的commit列表中会有如下信息：

![img](https:////upload-images.jianshu.io/upload_images/16146226-56531e99792ad355.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)



原文地址 ： https://www.jianshu.com/p/ff4f98695c2c

