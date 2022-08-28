---
title: 安装Ubuntu后另外磁盘出现只读的解决办法
date: 2022-02-12 09:55:38
tags:
---

mount 
blkid
sudo ntfsfix /dev/sdb1
mount -a

## 其他

### 卸载硬盘：

chen@ilaptop:/$ sudo umount /dev/sdb1

### 读写挂载硬盘

chen@ilaptop:/$ sudo mount -o rw /dev/sdb1

参考：https://jakting.com/archives/ubuntu-rw-windows-files.html