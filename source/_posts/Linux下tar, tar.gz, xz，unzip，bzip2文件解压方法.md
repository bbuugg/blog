---
title: Linux下tar, tar.gz, xz，unzip，bzip2文件解压方法
date: 2022-04-24 19:11:45
cover: https://tse1-mm.cn.bing.net/th/id/R-C.59ea81883a2d99c42444a7b9c0d581c8?rik=Ks1hzEuACgHScA&riu=http%3a%2f%2fdigitizor.com%2fwp-content%2fuploads%2f2009%2f10%2furl.png&ehk=8MNtdUfove24Besa%2fYqPXbe7hzdANF8GPbujtS8Y%2fH0%3d&risl=&pid=ImgRaw&r=0
tags:
---

## tar

```
tar -zxvf filename
```

- z 一般处理.gz文件
- x 解压 c压缩
- v 显示执行过程
- f 指定备份文件

<!-- more -->

压缩tar.gz

```shell
tar -zcvf dest.tar.gz ./ori/*  # 压缩一个目录
```

压缩包含隐藏文件

```
tar -zcvf  back.tar.gz .[!.]* *
```

> tar czvf test.tar.gz * 压缩当前文件夹下非[隐藏文件]的文件; tar czvf test.tar.gz .[!.]* 压缩当前文件夹下[隐藏文件]排除两个[隐藏文件]夹"."和“..”

先创建tar包最后删除

```
tar -cvzf  a.tar.gz a --remove-files
```

解压tar.gz

```shell
tar -zxvf origin.tar.gz
tar -zxvf origin.tar.gz -C /home 设置解压目录
```

## xz

解压.xz文件

```shell
xz -dk node-v14.15.1-linux-x64.tar.xz #将.xz解压为.tar
tar -xvf node-v14.15.1-linux-x64.tar # 将.tar解压为普通文件
tar -xvf node-v14.15.1-linux-x64.tar.xz
```

- d 解压.xz文件
- k 保留原文件（如果不想保留，可以去掉k）

```
xz -help

用法:xz[选项]…[文件]…
压缩或解压.xz格式的文件。
-z，——compress 压缩
-d，——decompress, --uncompress 解压
-t，——test 测试压缩文件的完整性
-l，——list 列出关于.xz文件的列表信息
-k，——keep 保留(不要删除)输入文件
-f，——force 强制重写输出文件和(de)压缩链接
-c，——stdout，——to-stdout 写入标准输出，不要删除输入文件
-0 …-9 压缩预设;默认是6;在使用7-9之前，请考虑压缩机和减压器的内存使用情况!
-e，——extreme 极端尝试提高压缩比使用更多的CPU时间; 不影响解压内存要求
-T，——threads=NUM使用最多的NUM线程;默认值为1;设置为0 使用任意多的处理器内核
-q，——quiet 安静压制警告;指定两次也可以抑制错误
-v，——verbose 啰嗦;如果要更详细，请指定两次
-h，——help 帮助显示此简短的帮助和退出
-H，——long-help 显示long help(同时列出高级选项)
-V，——version 版本显示版本号并退出
```

没有文件时，或文件为-时，读取标准输入。

## unzip

1、把文件解压到当前目录下

```
unzip test.zip
```

2、如果要把文件解压到指定的目录下，需要用到-d参数。

```
unzip -d /temp test.zip
```

3、解压的时候，有时候不想覆盖已经存在的文件，那么可以加上-n参数

```
unzip -n test.zip
unzip -n -d /temp test.zip
```

4、只看一下zip压缩包中包含哪些文件，不进行解压缩

```
unzip -l test.zip
```

5、查看显示的文件列表还包含压缩比率

```
unzip -v test.zip
```

6、检查zip文件是否损坏

```
unzip -t test.zip
```

7、将压缩文件test.zip在指定目录tmp下解压缩，如果已有相同的文件存在，要求unzip命令覆盖原先的文件

```
unzip -o test.zip -d /tmp/
```

## bzip2 

安装
```
sudo apt install bzip2
```

压缩

```
bzip2 filename
bzip2 -z filename
bzip2 -z backup.tar
```
> 重要：bzip2 默认会在压缩及解压缩文件时删除输入文件（原文件），要保留输入文件，使用-k或者--keep选项。此外，-f或者--force标志会强制让 bzip2 覆盖已有的输出文件

```
bzip2 -zk filename
bzip2 -zk backup.tar
```

> 你也可以设置块的大小，从 100k 到 900k，分别使用-1或者--fast到-9或者--best：

```
bzip2 -k1  Etcher-linux-x64.AppImage
ls -lh  Etcher-linux-x64.AppImage.bz2 
bzip2 -k9  Etcher-linux-x64.AppImage 
bzip2 -kf9  Etcher-linux-x64.AppImage 
ls -lh Etcher-linux-x64.AppImage.bz2 
```

解压

> 要解压缩.bz2文件，确保使用-d或者--decompress选项：

```
bzip2 -d filename.bz2
```

> 注意：这个文件必须是.bz2的扩展名，上面的命令才能使用。

```
bzip2 -vd Etcher-linux-x64.AppImage.bz2 
bzip2 -vfd Etcher-linux-x64.AppImage.bz2 
ls -l Etcher-linux-x64.AppImage 
```