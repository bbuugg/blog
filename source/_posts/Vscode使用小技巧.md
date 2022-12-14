---
title: Vscode使用小技巧
date: 2021-04-07 18:39:11
cover: /images/20221002/e49c28ada95f14ad22b9a1cd274f4a09.png
tags:
---

# vscode删除重复行并排序`
安装插件:`Transformer`

`ctrl + a` 全选文字
`ctrl + shift + P` 打开命令窗口
输入：
```
Transform:Unique Lines //删除重复行
```
或
```
Transform:Sort Lines //排序
```
更多功能，查看插件页面，有`git`动画示例

`vscode`删除行前的空格

输入`^\s`
选择使用正则表达式
`vscode`删除行尾的空格

输入`\s$`
选择使用正则表达式


<!-- more -->

# VScode多行编辑的设置
VScode对多行编辑有两种模式。

第一种模式

```
Alt+Shift   竖列选择
```

这种模式下只可以选择竖列，不可以随意插入光标。所以只限制于同一列且不间隔的情况下。

第二种模式

```
Shift+Ctrl 竖列选择
Ctrl+光标点击 选择多个编辑位点
```

这种模式下不仅可以选择竖列，同时还可以在多个地方插入光标。

两种模式的切换
使用`Shift+Ctrl+p`快捷键调用查询输入栏，输入`cursor`，列表中会出现“切换多行修改键”这个选项。选择这个选项就可以在两种模式下切换。

# 同时选中多个相同字符 多行 编辑

> ctrl + shift + L

同时选中多个相同的字符使用步骤如下，比如：冒号

1. 使用鼠标选中  冒号
2. ctrl + shift + L
3. 使用键盘左右箭头 ← → 可以移动至需要位置
4. 输入需要的数值

> alt + 鼠标左键点击单个选择

同时选中多行不同位置使用步骤如下，比如：冒号

1. 按住alt + 鼠标左键选择第一行目标位置
2. 重复第一步，选择目标行目标位置
3. 使用键盘左右箭头 ← → 可以移动至需要位置
4. 输入需要的数值

> alt + shift + 鼠标左键竖拉

> IDEA 选中多行相同的内容，快捷键ctrl+alt+shift+j

# 其他
选中字母后多次按下 ALT + J 选中多个相同的字母

# 解决VSCODE"因为在此系统上禁止运行脚本"报错

1. 以管理员身份运行vscode;
2. 执行：get-ExecutionPolicy，显示Restricted，表示状态是禁止的;
3. 执行：set-ExecutionPolicy RemoteSigned;
4. 这时再执行get-ExecutionPolicy，就显示RemoteSigned;