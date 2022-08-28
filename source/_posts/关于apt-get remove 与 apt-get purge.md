---
title: 关于apt-get remove 与 apt-get purge
date: 2020-08-14 16:35:58
tags:
---

今天在Ubuntu服务器上安装supervisor，部署没成功想卸载重来，sudo apt-get remove supervisor 后发现配置文件还在，便手动删除了配置文件。再次安装，提示配置文件不存在，WTF！配置文件不该你软件给我创建吗？我想。

查阅资料才知，还有 apt-get purge 这一选项，purge 清除。

划重点：
apt-get remove 会删除软件包而保留软件的配置文件
apt-get purge 会同时清除软件包和软件的配置文件

但是为什么重新安装会失败呢？
系统中存在dpkg这么一个工具，会记录软件包的状态，不只是安装和未安装两种状态，会记录以下这些状态：

not-installed - The package is not installed on this system
config-files - Only the configuration files are deployed to this system
half-installed - The installation of the package has been started, but not completed
unpacked - The package is unpacked, but not configured
half-configured - The package is unpacked and configuration has started but not completed
triggers-awaited - The package awaits trigger processing by another package
triggers-pending - The package has been triggered
installed - The packaged is unpacked and configured OK

当执行apt-get install时，apt软件包管理工具会先检查要安装的软件的状态，向我这种情况下，手动删除了软件配置后，并不会引起dpkg中记录的状态的改变，即仍为 config-files 状态，所以安装过程会直接跳过创建配置文件这一过程。于是当软件想要启动进程的时候，才发现找不到文件。

所以当你想彻底地删除软件包的时候，用 apt-get purge 吧

原文：http://bencane.com/2014/08/18/removing-packages-and-configurations-with-apt-get/
