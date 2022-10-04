---
title: Linux命令
date: 2021-11-07 17:26:40
cover: /images/20221002/481609447b841bc3b398b04756767e24.jpg
tags:
categories: linux
---

# 常用Linux命令

## ps

```
ps -ef | grep redis
```

根据进程id查找文件，找到pid，例如123

```
ls -lp /proc/123/cwd
```

<!-- more -->

# cat命令

&gt;连接文件并打印到标准输出设备上，cat经常用来显示文件的内容。

注意：当文件较大时，文本在屏幕上迅速闪过（滚屏），用户往往看不清所显示的内容。因此，一般用more等命令分屏显示。

为了控制滚屏，可以按Ctrl+S键，停止滚屏；按Ctrl+Q键可以恢复滚屏。按Ctrl+C（中断）键可以终止该命令的执行，并且返回Shell提示符状态。

- -n或-number：有1开始对所有输出的行数编号；

- -b或--number-nonblank：和-n相似，只不过对于空白行不编号；

- -s或--squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行；

- -A：显示不可打印字符，行尾显示“$”；

- -e：等价于&quot;-vE&quot;选项；

- -t：等价于&quot;-vT&quot;选项；

##从键盘创建一个文件

$ cat &gt; d.txt

##将几个文件合并为一个文件

$ cat c.txt d.txt &gt; e.txt

##显示一个文件的内容

$ cat e.txt

显示多个文件的内容

$ cat e.txt a.txt

对所有输出行编号

$ cat  -n e.txt

对非空输出行编号

$ cat -b e.txt

如果有连续两行以上的空白行，输出时只显示一行

$ cat -s e.txt

显示不可打印字符，输出时每行结尾会加上一个$

$ cat -A e.txt

将一个文件的内容加上行号后输入到另一个文件里（直接覆盖掉这个文件原来的内容）

$ cat -n e.txt &gt; a.txt

将一个文件的内容加上行号后输入到另一个文件里（在尾部追加）

$ cat -n e.txt &gt;&gt; a.txt

复制这个文件

$ cat  e.txt &gt; a.txt 

合并几个文件，并且test4是已经排好序的

$ cat test test1 test2 test3 | sort &gt; test4

如果有大量的文件包含不适合在输出端子和屏幕滚动起来非常快，我们可以多和少用参数与cat命令如上表演。

$ cat e.txt | more

$ cat e.txt | less

# tac命令

反序输出文件的内容，文件的最后一行显示在第一行

它可以对调试日志文件提供了很大的帮助，扭转日志内容的时间顺序。

$ tac e.txt

## lsattr, chattr 

查看和修改文件属性

## jobs

```
jobs -rp // 暂时不知到什么用
```

 查看挂起的进程，`kill %1` 可以停止`jobs`中标号为`1`的进程

也可以使用fg %1 来切到前台，部分可能不需要%

## stat

## awk
## zcat
## zgrep
## tee

```shell
# 将sql输入到文件back.sql
tee back.sql <<-'EOT'
insert into
users
(id)
values
1;
EOT
```

## sed

```
sed -e "1ititle:test" back.txt  // 给back.txt文件第一行前添加title:text
```

## jq 

> 解析json

```
echo '{"name": "max"}' | jq
```

## ls

```
ls -SX 按照文件类型排序，文件夹在前
ll -ht 按照时间排序
ll -hS 按照大小排序
```

https://www.cnblogs.com/ginvip/p/6351696.html

## nohup 

https://www.cnblogs.com/baby123/p/6477429.html

## pidof

https://www.cnblogs.com/fengzhilaoling/p/12269923.html

## kill

https://blog.csdn.net/u010486679/article/details/78415666

## hostname

https://blog.csdn.net/qhairen/article/details/45913465

## expr

```
expr 1 + 2
expr lentdh "test"
```

[Linux expr命令 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-comm-expr.html)

## lscpu

查看CPU信息

## lsmem

查看内存信息

## cut

cut命令用于显示每行从开头算起 num1 到 num2 的文字

[Linux cut命令 | 菜鸟教程 (runoob.com)](https://www.runoob.com/linux/linux-comm-cut.html)

## netcat

[(38条消息) Linux系统终端命令：netcat的基本使用_麒麒川的博客-CSDN博客_linux netcat](https://blog.csdn.net/wangqingchuan92/article/details/79666885)

## systemctl

```
systemctl status -l
```

## ssh

```
ssh -n -x
```

## ssh-keygen

```
ssh-keygen -t rsa
ssh-keygen -A
```

## htop

## locate

```
updatedb 更新locatedb
```

## find

## free

## tree

## alias

# 调试

## objdump

## gdb

# PHP相关

```
php --ri grpc  // 查看swoole扩展
php -l index.php // 检查语法错误
```

# 安装build-essential
```shell
apt-get install build-essential
```

# lrzsz，可以在ssh终端中上传和下载文件

# 安装

ubuntu下
```
sudo apt install lrzsz
```
或者编译安装
```
tar zxvf lrzsz-0.12.20.tar.gz
cd lrzsz-0.12.20
./configure
make
make install
```

> 上面安装过程默认把lsz和lrz安装到了/usr/local/bin/目录下,可以建立一个软连接

```
cd /usr/bin
ln -s /usr/local/bin/lrz rz
ln -s /usr/local/bin/lsz sz
```

上传
```
rz
```

下载
```
sz <filename>
```

# killall

命令找不到，可以用下面的命令安装
```
apt-get install psmisc
```

# put上传ftp文件

**put**

   使用lftp登录ftp服务器之后，可以使用put指令将文件上传到服务器。

##语法

   **put [-E] [-a] [-c] [-O base] lfile [-o rfile]**

##选项列表

| 选项   | 说明                                       |
| ------ | ------------------------------------------ |
| **-o** | 指定输出文件的名字，不指定则使用原来的名字 |
| **-c** | 如果失败，持续获取                         |
| **-E** | 获取之后，删除源文件                       |
| **-a** | 使用ascii模式                              |
| **-O** | 指定输出文件存放的目录                     |

##实例

上传文件

```shell
[root@localhost weijie]# lftp 192.168.1.8          //登录服务器

lftp 192.168.1.8:~> cd pub/                           //切换目录

lftp 192.168.1.8:/pub> put 3.c                       //上传文件

65 bytes transferred

lftp 192.168.1.8:/pub> ls                             //查看内容，已经上传成功

-rwxrwxrwx    1 0        0        2375494044 Aug 14 06:38 1.zip

-rw-r--r--    1 0       0               0 Oct 02 01:19 11c

-rw-r--r--    1 0       0               0 Oct 02 01:19 22c

-rw-------    1 14      50             65 Oct 02 01:48 3.c

drwxr-xr-x    2 0       0            4096 Oct 02 01:12 testftp

lftp 192.168.1.8:/pub> 
```



# 测试端口

>linux测试某个端口的bai连通性可以du使用zhi如下命令测试daoTCP协议

```
telnet  ip  port
```

TCP/UDP协议测试zhuan端口

```
nc -vuz ip  port #测试udp协议
nc -vtz ip port  #测试tcp协议
```

端口扫描 nc -z -v -n 192.168.21.135 1-100 z参数告诉nc使用0 输入/输出模式，一般在扫描通信端口的时候使用

```
Nc -z -v -n 192.168.21.135 1-100 # 检测1-100端口
Nc -z -v -n 192.168.21.135 8989  #检测8989端口
```

## lsof 
> 你可以使用 lsof 命令来查看某一端口是否开放。查看端口可以这样来使用，我就以80端口为例：

lsof -i:80
或者
lsof -i:22
如果有显示说明已经开放了，如果没有显示说明没有开放
##netstat -aptn
是否监听在0.0.0.0:3306
## 其他方式
netstat -nupl (UDP类型的端口)
netstat -ntpl (TCP类型的端口)
## telnet ip端口号 方式

>测试远程主机端口是否打开

telnet 127.0.0.1 3306


#其他命令

## 删除输入的错误

有时候在linux终端中执行某个命令时，往往会输错命令，想删除掉重敲可以按backspace键，但这样较慢，一种简便技巧是，按住esc键同时按backspace键会较快删除【esc+backspace】组合键。或者【ctrl+u】组合键

当然，直接回车更直接，但可能会产生一堆的错误提示。
##vim
v / ctrl + v 可视模式，< > 缩进，d,D,y dw d$

vim :行号，行号< 回车  可以缩进

vim中统计文字出现次数 :%s/name//gn

##其他
lha 
linux 的 ls -1 和 -l
shell 的[ -s file] 文件大小不为0为真 elif
lcd  put lftp
psql -c -f
https://www.cnblogs.com/ftl1012/p/ssh.html
https://www.cnblogs.com/hmwh/p/11015439.html

telnet
```
telnet 127.0.0.1 9501
```
退出 `ctrl` + `]` 再按`ctrl` + `d` 或者输入 `quit`

# 笔记

# linux

vim ctrl + g 显示当前编辑的文件名

1. `sudo nautilus`   	`ubuntu`以管理员方式打开文件可视化文件管理器 

2. `apt install build-essential` ubuntu安装需要的文件

3. `du -sh`  `df -h` 查看硬盘占用情况

4. `wc -l -w -c / -lwc` 统计行数，字数字节数

5. 排除`grep -v` 包含  `egrep/grep -e 'a|b|c' 路径` 可以使用正则

6. `cat /tac` `tail` `head` 

7. `ps -ef/af/x/aux` 不与终端有关的进程也显示出来 

8. `pstree -Aup` kill -9 强制结束 kill -2 相当于ctrl+c

9. 数字+G` 跳行，`数字+D` 删除 `数字+Y`复制，`:setnu`显示行号，`G/gg` ，`dd`剪切

10. `su + username` 切换用户 `ctrl + d` 注销 `sudo -l` 查看自己的权限  `visudo` 修改用户权限 `admin[`用户] `ALL`[允许登录的主机]=`(ALL`[以root运行]`) ALL`[所有命令]

11. `[%]s/搜索内容/替换内容/[g]` %表示替换所有，没有g表示一行，有g表示所有

12. `netstat -tunpl | grep 80` 查看80口占用 `-ano` `-lntp`列出系统里监听网络链接的端口号和相应进程pid 

13. `lsof [-i :80]` 列出当前系统打开的文件(listen opened files)

14. ubuntu-drivers devices 查看可以安装的闭源显卡驱动

15. apt editor-sources 修改源 

16. select-editor 更换默认编辑器

17. chown/chgrp -R 用户名/组名 文档  chown -R username:group /etc/文件...同时修改

18. rsync

19. {d}{rwx}{rwx}{rwx} -> d表示文件夹，rwx-1 表示拥有者，rwx-2表示用户所在组，rwx-3表示其他人，使用chmod修改权限 chmod ug+w,o-w file1.txt file2.txt 给file1.txt 和file2.txt 加上对用户和用户组的写权限，去掉其他人的写权限

20. 清空文件 gg跳到行首dG清空

21. ctrl-c 发送 SIGINT 信号给前台进程bai组中的所有进du程。常用于终止正在运zhi行的程序。
    ctrl-z 发送 SIGTSTP 信号给前台进程dao组中的所有进程，常用于挂起一个进程。用户可以使用fg/bg操作继续前台或后台的任务，fg命令重新启动前台被中断的任务,bg命令把被中断的任务放在后台执行.
    ctrl-d 不是发送信号，而是表示一个特殊的二进制值，表示 EOF。
    ctrl-\ 发送 SIGQUIT 信号给前台进程组中的所有进程，终止前台进程并生成 core 文件。

22. linux添加计划任务                                                        

    crond 是linux用来定期执行程序的命令。当安装完成操作系统之后，默认便会启动此任务调度命令。crond命令每分锺会定期检查是否有要执行的工作，如果有要执行的工作便会自动执行该工作。可以用以下的方法启动、关闭这个服务:

    /sbin/service crond start //启动服务

    /sbin/service crond stop //关闭服务

    /sbin/service crond restart //重启服务

    /sbin/service crond reload //重新载入配置

    1.linux任务调度的工作主要分为以下两类：

    *系统执行的工作：系统周期性所要执行的工作，如备份系统数据、清理缓存

    *个人执行的工作：某个用户定期要做的工作，例如每隔10分钟检查邮件服务器是否有新信，这些工作可由每个用户自行设置。

    2.crontab命令选项:

    cron服务提供crontab命令来设定cron服务的，以下是这个命令的一些参数与说明:

    crontab -u //设定某个用户的cron服务，一般root用户在执行这个命令的时候需要此参数

    crontab -l //列出某个用户cron服务的详细内容

    crontab -r //删除没个用户的cron服务

    crontab -e //编辑某个用户的cron服务

    比如说root查看自己的cron设置:crontab -u root -l

    再例如，root想删除fred的cron设置:crontab -u fred -r

    在编辑cron服务时，编辑的内容有一些格式和约定，输入:crontab -u root -e

    进入vi编辑模式，编辑的内容一定要符合下面的格式:*/1 * * * * ls >> /tmp/ls.txt

    3.cron文件语法

      分   小时   日    月    星期   命令

     0-59  0-23  1-31  1-12   0-6   command   (取值范围,0表示周日一般一行对应一个任务)

    4.记住几个特殊符号的含义:

    "*"代表取值范围内的数字,

    "/"代表"每",

    "-"代表从某个数字到某个数字,

    ","分开几个离散的数字

    5.举几个例子

    5    *    *    *   *   ls       //指定每小时的第5分钟执行一次ls命令

    30   5    *    *   *   ls       //指定每天的 5:30 执行ls命令

    30   7    8    *   *   ls       //指定每月8号的7：30分执行ls命令

    30   5    8    6   *   ls       //指定每年的6月8日5：30执行ls命令

    30   6    *    *   0   ls       //指定每星期日的6:30执行ls命令[注：0表示星期天，1表示星期1，以此类推，也可以用英文来表示，sun表示星期天，mon表示星期一等。]

    30   3  10,20   *   *   ls       //每月10号及20号的3：30执行ls命令[注：”,”用来连接多个不连续的时段]

    25   8-11 *    *   *   ls       //每天8-11点的第25分钟执行ls命令[注：”-”用来连接连续的时段]

    */15  *   *    *   *   ls      //每15分钟执行一次ls命令 [即每个小时的第0 15 30 45 60分钟执行ls命令 ]

    30   6  */10   *   *   ls      //每个月中，每隔10天6:30执行一次ls命令[即每月的1、11、21、31日是的6：30执行一次ls命令。 ]

    50   7    *     *   *   root run-parts /etc/cron.daily   //每天7：50以root 身份执行/etc/cron.daily目录中的所有可执行文件[  注：run-parts参数表示，执行后面目录中的所有可执行文件。 ]

    6.新增调度任务可用两种方法：

    a.在命令行输入: crontab -e 然后添加相应的任务，wq存盘退出。

    b.直接编辑/etc/crontab 文件，即vi /etc/crontab，添加相应的任务。

23. `lsb_release -a` ubuntu 查看版本信息 

    uname [参数]

    ```csharp
    $ uname -a　　//显示所有信息
    Linux BigManing 4.4.0-83-generic #106-Ubuntu SMP Mon Jun 26 17:54:43 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
    
    $ uname -s　　//显示内核名称
    Linux
    
    $ uname -n　　//显示网络节点上的主机名
    BigManing
    
    $ uname -r　　//显示内核发行号
    4.4.0-83-generic
    
    $ uname -v　　　//显示内核版本号
    #106-Ubuntu SMP Mon Jun 26 17:54:43 UTC 2017
        $ uname -m　　　//显示机器硬件名称　显示i686说明你安装了32位操作系统　　　显示 x86_64说明你安装了64位操作系统
    x86_64
    
    $ uname -p　　　//显示处理器类型
    x86_64
    
    $ uname -i　　　//显示硬件平台
    x86_64
    
    $ uname -o　　　//操作系统
    GNU/Linux
    ```

24. wget在下载的时候就重命名:

    `wget -c "www.baidu.com" -O baidu.index.html`
    保存输出日至，可以使用:

    `wget -c "www.baidu.com" -O baidu.index.html -o wget.log`

    递归下载

    ```shell
    $ wget -r -p -np -k http://archives.fedoraproject.org/pub/archive/epel/5Server/x86_64/
    $ wget -r -p -np -k http://archives.fedoraproject.org/pub/epel/6Server/x86_64/
    -c,  --continue                 resume getting a partially-downloaded file. 断点续传
    -nd, --no-directories           don't create directories. 不创建层级目录，所有文件下载到当前目录
    -r,  --recursive                specify recursive download. 递归下载
    -p,  --page-requisites          get all images, etc. needed to display HTML page. 下载页面所有文件，使页面能在本地打开
    -k,  --convert-links            make links in downloaded HTML or CSS point to local files. 转换链接指向本地文件
    -np, --no-parent                don't ascend to the parent directory. 不下载父级目录的文件
    -o,  --output-file=FILE         log messages to FILE. 指定日志输出文件
    -O,  --output-document=FILE     write documents to FILE. 指定文件下载位置
    -L,  --relative                 follow relative links only. 只下载相对链接，如果页面嵌入其他站点不会被下载
    wget -m<镜像/整站抓取> -e rebots=off<忽略robots协议> -k<将绝对url转换为本地相对url> -E<将所有text/html以html扩展名保存> 'http://baidu,com'
    
    ```

fdisk -l
lsblk -f

创建两个文件
touch app.{js,css}

### linux下如何输入EOF
```
ctrl + d 
```
不同系统有不同组合键

```
int main(int argc, char *argv[])
{
	int c;
	while ((c = getc(stdin)) != EOF)
	{
		putc(c, stdout);
	}
}
```

## umask

```
umask 022
```

# 查看进程占用网速和流量使用情况

> 有三个命令vnstat、iftop、nethogs（推荐）

## vnstat

```shell
vnstat -i eth0 -l #实时流量情况
```

## iftop

iftop可以用来监控网卡的实时流量（可以指定网段）、反向解析IP、显示端口信息等

### 命令用法：

- -i设定监测的网卡，如：# iftop -i eth1
- -B 以bytes为单位显示流量(默认是bits)，如：# iftop -B
- -n使host信息默认直接都显示IP，如：# iftop -n
- -N使端口信息默认直接都显示端口号，如: # iftop -N

### 交互命令：

- 按n切换显示本机的IP或主机名;
- 按s切换是否显示本机的host信息;
- 按d切换是否显示远端目标主机的host信息;
- 按t切换显示格式为2行/1行/只显示发送流量/只显示接收流- 量;
- 按N切换显示端口号或端口服务名称;
- 按S切换是否显示本机的端口信息;
- 按D切换是否显示远端目标主机的端口信息;
- 按p切换是否显示端口信息;

## nethogs

> 按进程实时统计网络带宽利用率(推荐)

### 命令用法：

- 设置5秒钟刷新一次，通过-d来指定刷新频率：nethogs -d 5
- 监视eth0网络带宽 :nethogs eth0
- 同时监视eth0和eth1接口 : nethogs eth0 eth1

### 交互命令：

以下是NetHogs的一些交互命令(键盘快捷键)

- m : 修改单位
- r : 按流量排序
- s : 按发送流量排序
- q : 退出命令提示符

### 匹配进程名结束进程

ps -ef | grep 进程名 | awk '{ print $2 }' | xargs kill -9

### expect

```shell
#!/usr/bin/expect
set user "git账号"
set pass "密码"
set timeout 10

spawn git pull # spawn启动新的进程
expect "Username*" # 匹配username*
send "$user\n" #发送账号到进程内
expect "Password*" # 匹配password
send "$pass\n" #发送密码到进程内
expect eof

expect -f pull.sh #运行脚本
```

## 查看公网ip

```shell
curl ifconfig.me
```