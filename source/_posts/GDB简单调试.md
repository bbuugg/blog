---
title: GDB简单调试
date: 2022-07-04 19:09:31
tags:
---

```go
package main

func main() {
    for i := 0; i < 10; i++ {
        fmt.Println(i)    
    }
}
```

编译

```shell
go build -o main main.go
```

调试

```shell
gdb main
```

如下

```shell
GNU gdb (Ubuntu 9.2-0ubuntu1~20.04) 9.2
Copyright (C) 2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from test...
warning: File "/usr/local/go/src/runtime/runtime-gdb.py" auto-loading has been declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load".
To enable execution of this file add
        add-auto-load-safe-path /usr/local/go/src/runtime/runtime-gdb.py
line to your configuration file "/root/.gdbinit".
To completely disable this security protection add
        set auto-load safe-path /
line to your configuration file "/root/.gdbinit".
For more information about this security protection see the
"Auto-loading safe path" section in the GDB manual.  E.g., run from the shell:
        info "(gdb)Auto-loading safe path"
(gdb) 
```

输入`l`回车查看源码，可以使用`l <line>` 跳到某一行查看

```
(gdb) l
1       package main
2
3       import (
4               "fmt"
5       )
6
7       func main() {
8               for i := 0; i < 10; i++ {
9                       fmt.Print(i)
10              }
(gdb)
```

设置断点`b <line>`，例如 `b 9`

```
(gdb) b 9
Breakpoint 1 at 0x49766a: file /mnt/c/Users/ChengYao/Desktop/Web/Go/test.go, line 9.
(gdb)
```

运行`run`

```
(gdb) run
Starting program: /mnt/c/Users/ChengYao/Desktop/Web/Go/test 
[New LWP 10861]
[New LWP 10862]
[New LWP 10863]
[New LWP 10864]
[New LWP 10865]

Thread 1 "test" hit Breakpoint 1, main.main () at /mnt/c/Users/ChengYao/Desktop/Web/Go/test.go:9
9                       fmt.Print(i)
(gdb)
```

打印变量`p <var>`， 例如 `p i`

```
(gdb) p i
$1 = 0
(gdb)
```

下一行`n `

```
(gdb) n
08              for i := 0; i < 10; i++ {
(gdb)
```